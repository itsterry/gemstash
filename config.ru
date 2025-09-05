require "gemstash"
require "rack"

# Custom Rack middleware for rewriting /versions to /dependencies
class VersionsToDependenciesRewrite
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    # Match requests to /private/api/v1/versions?gems=<gem_name>
    if request.path =~ %r{^/private/api/v1/versions} && request.params["gems"]
      # Rewrite the path to /private/api/v1/dependencies, preserving query params
      env["PATH_INFO"] = "/private/api/v1/dependencies"
      env["REQUEST_URI"] = "/private/api/v1/dependencies?#{request.query_string}" if env["REQUEST_URI"]
    end
    # Match requests to /private/api/v1/versions/<gem>.json
    if request.path =~ %r{^/private/api/v1/versions/(.+)\.json$}
      gem_name = ::Regexp.last_match(1)
      env["PATH_INFO"] = "/private/api/v1/dependencies"
      env["QUERY_STRING"] = "gems=#{gem_name}"
      env["REQUEST_URI"] = "/private/api/v1/dependencies?gems=#{gem_name}" if env["REQUEST_URI"]
    end
    @app.call(env)
  end
end

# Existing apps
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

# Apply the rewrite middleware before routing
use VersionsToDependenciesRewrite

# Existing URL mappings
run Rack::URLMap.new(
  "/up"    => health_app,
  "/"      => root_app,
  "/stats" => stats_app,
  "/gems"  => gemstash_app,
  "/api"   => gemstash_app
)
