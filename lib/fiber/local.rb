# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Samuel Williams.

require_relative "local/version"

class Fiber
	module Local
		# Instantiate a new thread-local object.
		# By default, invokes {new} to generate the instance.
		# @returns [Object]
		def local
			self.new
		end
		
		# Get the current thread-local instance. Create it if required.
		# @returns [Object] The thread-local instance.
		def instance
			thread = Thread.current
			name = self.name
			
			if instance = thread[self.name]
				return instance
			end
			
			unless instance = thread.thread_variable_get(name)
				if instance = self.local
					thread.thread_variable_set(name, instance)
				end
			end
			
			thread[self.name] = instance
			
			return instance
		end
		
		# Assigns to the fiber-local instance.
		# @parameter instance [Object] The object that will become the thread-local instance.
		def instance= instance
			thread = Thread.current
			thread[self.name] = instance
		end
	end
end
