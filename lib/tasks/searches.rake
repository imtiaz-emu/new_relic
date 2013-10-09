desc "Remove searches older than an hour"
task :remove_old_searches => :environment do
  Search.delete_all ["created_at < ?", 1.hour.ago]
end