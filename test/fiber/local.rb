# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require 'fiber/local'

class MyThing
	extend Fiber::Local
end

describe Fiber::Local do
	it "has a version number" do
		expect(Fiber::Local::VERSION).to be =~ /\d+\.\d+\.\d+/
	end
	
	with '#instance' do
		it "creates unique instances in different threads" do
			instance1 = Thread.new do
				MyThing.instance
			end.value
			
			instance2 = Thread.new do
				MyThing.instance
			end.value
			
			expect(instance1).not.to be_equal(instance2)
		end
		
		it "returns same instance in same thread" do
			expect(MyThing.instance).to be_equal(MyThing.instance)
		end
		
		it "inherits assigned values in nested fibers" do
			instance = Object.new
			
			storage = Fiber.new do
				MyThing.instance = instance
				expect(MyThing.instance).to be_equal(instance)
				
				Fiber.new do
					expect(MyThing.instance).to be_equal(instance)
					
					Fiber.current.storage
				end.resume
			end.resume
			
			expect(storage).to have_keys(
				MyThing.fiber_local_attribute_name => be_equal(instance)
			)
		end
	end
	
	with '#instance=' do
		let(:object) {Object.new}
		
		it "can assign an object to the fiber local instance" do
			MyThing.instance = object
			
			expect(MyThing.instance).to be_equal(object)
		end
		
		it "has fiber local scope" do
			Fiber.new do
				MyThing.instance = object
				expect(MyThing.instance).to be_equal(object)
			end
			
			expect(MyThing.instance).not.to be_equal(object)
		end
	end
end
