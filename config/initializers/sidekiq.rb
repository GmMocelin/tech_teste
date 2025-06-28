Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }

  schedule_file = "config/schedule.yml"
  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Scheduler.load_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end