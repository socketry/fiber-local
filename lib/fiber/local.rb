# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require_relative "local/version"

class Fiber
	module Local
		def self.extended(klass)
			instance_attribute_name = klass.name.gsub('::', '_').gsub(/\W/, '').downcase
			klass.instance_variable_set(:@instance_attribute_name, instance_attribute_name)
			klass.instance_variable_set(:@instance_variable_name, :"@#{instance_attribute_name}")
			
			Thread.attr_accessor(instance_attribute_name)
		end
		
		# Instantiate a new thread-local object.
		# By default, invokes {new} to generate the instance.
		# @returns [Object]
		def local
			self.new
		end
		
		# Get the current thread-local instance. Create it if required.
		# @returns [Object] The thread-local instance.
		def instance
			if instance = Fiber[@instance_variable_name]
				return instance
			end
			
			thread = Thread.current
			unless instance = thread.instance_variable_get(@instance_variable_name)
				if instance = self.local
					thread.instance_variable_set(@instance_variable_name, instance)
				end
			end
			
			return instance
		end
		
		# Assigns to the fiber-local instance.
		# @parameter instance [Object] The object that will become the thread-local instance.
		def instance= instance
			Fiber[@instance_variable_name] = instance
		end
	end
end
