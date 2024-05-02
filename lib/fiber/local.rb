# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
