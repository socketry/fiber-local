# frozen_string_literal: true

require_relative "lib/fiber/local/version"

Gem::Specification.new do |spec|
	spec.name = "fiber-local"
	spec.version = Fiber::Local::VERSION
	
	spec.summary = "Provides a class-level mixin to make fiber local state easy."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/socketry/fiber-local"
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.5.0"
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rspec"
end
