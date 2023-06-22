# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Samuel Williams.

require 'fiber/local'

class MyThing
	extend Fiber::Local
end

RSpec.describe Fiber::Local do
	it "has a version number" do
		expect(Fiber::Local::VERSION).not_to be nil
	end
	
	describe '#instance' do
		it "creates unique instances in different threads" do
			instance1 = Thread.new do
				MyThing.instance
			end.value
			
			instance2 = Thread.new do
				MyThing.instance
			end.value
			
			expect(instance1).to_not be instance2
		end
		
		it "returns same instance in same thread" do
			expect(MyThing.instance).to be MyThing.instance
		end
	end
	
	describe '#instance=' do
		let(:object) {Object.new}
		
		it "can assign an object to the fiber local instance" do
			MyThing.instance = object
			
			expect(MyThing.instance).to be object
		end
		
		it "has fiber local scope" do
			Fiber.new do
				MyThing.instance = object
				expect(MyThing.instance).to be object
			end
			
			expect(MyThing.instance).to_not be object
		end
	end
end
