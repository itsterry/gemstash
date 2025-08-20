require "gemstash"

Gemstash::Env.config_file = File.expand_path("config.yml", __dir__)

run Gemstash::Web
