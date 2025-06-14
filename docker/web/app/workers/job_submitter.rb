class JobSubmitter
  include Sidekiq::Worker
  
  sidekiq_options lock: :until_executed

  WORKER_ID = :submitter
  WORKER_LOG_FILE = Rails.root.join('log', "job_submitter_worker.log")
  WORKER_STDOUT_FILE = Rails.root.join('log', "job_submitter_worker_out.log")

  def perform()
    logger = LoggerForWorker.new(self.class::WORKER_ID, self.class::WORKER_LOG_FILE, 7)
    logger.debug("starting #{self.class}")

    @last_performed_at ||= {}
    destroy_jobs_to_be_destroyed(logger)
    Host.where(status: :enabled).each do |host|
      break if $term_received
      next if DateTime.now.to_i - @last_performed_at[host.id].to_i < host.polling_interval
      begin
        num = host.max_num_jobs - host.submitted_runs.count - host.submitted_analyses.count
        logger.debug "checking jobs going to be submitted to #{host.name}."
        if num > 0 and (host.submittable_analyses.count > 0 or host.submittable_runs.count > 0)
          host.start_ssh_shell do |sh|
            prev_num = num
            Run::PRIORITY_ORDER.keys.sort.each do |priority|
              break if $term_received
              break unless num > 0
              analyses = host.submittable_analyses.where(priority: priority).asc(:created_at).limit(num)
              if analyses.present?
                logger.info("submitting analyses to #{host.name}: #{analyses.map do |r| r.id.to_s end.inspect}")
                num -= analyses.length  # [warning] analyses.length ignore 'limit', so 'num' can be negative.
                bm = Benchmark.measure {
                  submit(analyses, host, logger)
                }
                logger.info("submission of analyses (host:#{host.name}, pri:#{priority}) finished in #{sprintf('%.1f', bm.real)}")
              else
                logger.debug("no submittable analyses of priority #{priority} found for #{host.name}")
              end

              break if $term_received
              break unless num > 0
              runs = host.submittable_runs.where(priority: priority).asc(:created_at).limit(num)
              if runs.present?
                logger.info("submitting runs to #{host.name}: #{runs.map do |r| r.id.to_s end.inspect}")
                num -= runs.length  # [warning] runs.length ignore 'limit', so 'num' can be negative.
                bm = Benchmark.measure {
                  submit(runs, host, logger)
                }
                logger.info("submission of runs (host:#{host.name}, pri:#{priority}) finished in #{sprintf('%.1f', bm.real)}")
              else
                logger.debug("no submittable runs of priority #{priority} found for #{host.name}")
              end
            end
            if num == prev_num
              logger.debug("no submittable runs or analyses is found for #{host.name}")
            end
          end
        end
      rescue => ex
        logger.error("Error in JobSubmitter: #{ex.inspect}")
        logger.error(ex.backtrace)
      end
      @last_performed_at[host.id] = DateTime.now
    end
  end

  private
  def submit(submittables, host, logger)
    # call start_ssh_shell in order to avoid establishing SSH connection for each run
    host.start_ssh_shell do |sh|
      handler = RemoteJobHandler.new(host)
      submittables.each do |job|
        break if $term_received
        begin
          logger.debug("submitting #{job.id} to #{host.name}")
          bm = Benchmark.measure {
            handler.submit_remote_job(job)
          }
          logger.info("submission of #{job.id} finished in #{sprintf('%.1f', bm.real)}")
        rescue => ex
          logger.error ex.inspect
          logger.error ex.backtrace
        end
      end
    end
  end

  def destroy_jobs_to_be_destroyed(logger)
    Run.where(status: :created, to_be_destroyed: true).each do |run|
      if run.destroyable?
        logger.debug "Deleting Run #{run.id}"
        run.destroy
        logger.info "Deleted Run #{run.id}"
      else
        logger.warn("should not happen: #{job.class}:#{job.id} is not destroyable")
        run.set_lower_submittable_to_be_destroyed
      end
    end
    Analysis.where(status: :created, to_be_destroyed: true).each do |anl|
      if anl.destroyable?
        logger.debug "Deleting Analysis #{anl.id}"
        anl.destroy
        logger.info "Deleted Analysis #{anl.id}"
      else
        logger.debug "Analysis #{anl.id} is not destroyable yet"
      end
    end
  end
end