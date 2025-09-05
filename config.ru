require "gemstash"
require "rack"

gemstash_app = Gemstash::Web

health_app = proc do |env|
  [200, { "Content-Type" => "text/plain" }, ["healthy"]]
end

root_app = proc do |env|
  [200, { "Content-Type" => "text/plain" }, ["Welcome to Gemstash Private Server"]]
end

stats_app = proc do |env|
  [200, { "Content-Type" => "application/json" }, ['{"stats":{"status":"OK","message":"Gemstash is running"}}']]
end

run Rack::URLMap.new(
  "/up"    => health_app,
  "/"      => root_app,
  "/stats" => stats_app,
  "/gems"  => gemstash_app,
  "/api"   => gemstash_app
)
