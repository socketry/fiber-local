# frozen_string_literal: true

require_relative "lib/fiber/local/version"

Gem::Specification.new do |spec|
	spec.name = "fiber-local"
	spec.version = Fiber::Local::VERSION
	
	spec.summary = "Provides a class-level mixin to make fiber local state easy."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/fiber-local"
	
	spec.metadata = {
		"source_code_uri" => "https://github.com/socketry/fiber-local.git",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "fiber-storage"
end
