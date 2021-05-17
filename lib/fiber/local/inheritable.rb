
require 'fiber'
require 'securerandom'

class Fiber
	module Local
		module Inheritable
			def initialize(**options)
				super(**options)
				
				self.inherit_attributes_from(Fiber.current)
			end
			
			def self.prepended(klass)
				klass.extend(Singleton)
				klass.instance_variable_set(:@inheritable_attributes, Hash.new)
			end
			
			module Singleton
				def inheritable(key, default: nil)
					@inheritable_attributes[:"@#{key}"] = default
				end
				
				def inheritable_attributes
					@inheritable_attributes
				end
			end
			
			def inherit_attributes_from(fiber)
				self.class.inheritable_attributes.each do |name, default|
					value = fiber.instance_variable_get(name) || default
					self.instance_variable_set(name, value)
				end
			end
		end
	end
end

unless Fiber.respond_to?(:inheritable)
	Fiber.prepend(Fiber::Local::Inheritable)
end
