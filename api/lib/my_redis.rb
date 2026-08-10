require 'redis'
# $redis = Redis.new(Rails.application.config_for(:redis))
$redis = Redis.new(
  url: Rails.application.config_for(:redis)[:url]
)
