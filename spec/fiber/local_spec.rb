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
