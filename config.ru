require "gemstash"

Gemstash::Env.config_file = File.expand_path("config.yml", __dir__)

gemstash_app = Gemstash::Web

health_app = proc do |env|
  [200, { "Content-Type" => "text/plain" }, ["healthy"]]
end

run Rack::URLMap.new(
  "/up" => health_app,
  "/"       => gemstash_app
)
