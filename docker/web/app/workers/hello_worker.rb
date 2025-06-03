class HelloWorker
  include Sidekiq::Worker

  def perform(*args)
    puts 'Hello world'    # Do something
  end
end