# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021, by Samuel Williams.

require_relative '../lib/fiber/local'

require 'securerandom'

module RequestID
	extend Fiber::Local
end

Fiber.new do
	RequestID.instance = SecureRandom.uuid
	
	pp RequestID.instance
	
	pp Fiber.current
	
	Fiber.new do
		pp RequestID.instance
	end.resume
end.resume

