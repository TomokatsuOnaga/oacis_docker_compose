class ParameterSetsCreator
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed

  WORKER_ID = :service
  WORKER_LOG_FILE = Rails.root.join('log', "service_worker.log")
  WORKER_STDOUT_FILE = Rails.root.join('log', "service_worker_out.log")

  def perform()
    logger = LoggerForWorker.new(self.class::WORKER_ID, self.class::WORKER_LOG_FILE, 7)
    logger.debug("starting #{self.class}")
    
    SaveTask.all.each do |task|
      begin
        logger.debug("creating PS in batch. Task: #{task.id}")
        task.make_ps_in_batches
        sim = task.simulator
        StatusChannel.broadcast_to('message', OacisChannelUtil.progressSaveTaskMessage(sim, -task.creation_size, -task.creation_size*task.num_runs))
      ensure
        task.destroy
      end
      break if $term_received
    end
  rescue => ex
    logger.error("Error in ParameterSetsCreator: #{ex.inspect}")
  end
end

