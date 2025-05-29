# frozen_string_literal: true

require_relative '../../config/environment'
require_relative '../../app/workers/job_submitter_worker'

class StandaloneJobSubmitterWorker
  def self.run
    puts "Starting JobSubmitterWorker in Docker mode"

    loop do
      begin
        JobSubmitterWorker.new.send(:do_work)
      rescue => e
        puts "Error: #{e.message}"
        puts e.backtrace
      end
      sleep 5
    end
  end
end

if $0 == __FILE__
  StandaloneJobSubmitterWorker.run
end