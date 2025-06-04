class DocumentDestroyer
  include Sidekiq::Worker

  INTERVAL = 5

  WORKER_ID = :service
  WORKER_PID_FILE = Rails.root.join('tmp', 'pids', "service_worker.pid")
  WORKER_LOG_FILE = Rails.root.join('log', "service_worker.log")
  WORKER_STDOUT_FILE = Rails.root.join('log', "service_worker_out.log")

  def perform()
    logger = LoggerForWorker.new(self.class::WORKER_ID, self.class::WORKER_LOG_FILE, 7)
    logger.info("starting #{self.class}")
    @logger = logger

    destroy_documents( Simulator.where(to_be_destroyed: true) )
    destroy_documents( ParameterSet.where(to_be_destroyed: true) )
    destroy_documents( Analyzer.where(to_be_destroyed: true) )
    destroy_documents(
      Run.where(:to_be_destroyed => true, :status.in => [:finished, :failed])
    )
    destroy_documents(
      Analysis.where(:to_be_destroyed => true, :status.in => [:finished, :failed])
    )

  rescue => ex
    logger.error("Error in DocumentDestroyer: #{ex.inspect}")
  end

  def destroy_documents(query)
    if query.empty?
      @logger.debug "No document to be deleted is found"
    end
    query.each do |obj|
      if obj.destroyable?
        @logger.info "destroying #{obj.class} #{obj.id}"
        obj.destroy
      else
        obj.set_lower_submittable_to_be_destroyed
        @logger.info "skip destroying #{obj.class} #{obj.id}. not destroyable yet."
      end
    end
  end
end
