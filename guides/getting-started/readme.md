# Getting Started

This guide will explain how and why to use `Fiber::Local` to simplify fiber-local state.

## Installation

Add the gem to your project:

``` bash
$ bundle add fiber-local
```

## Core Concepts

- {ruby Fiber::Local} is a module which exposes an instance of something as fiber-local state.

## Usage

In your own class, e.g. `Logger`:

``` ruby
class Logger
	extend Fiber::Local
	
	def initialize
		@buffer = []
	end
	
	def log(*arguments)
		@buffer << arguments
	end
end
```

Now, instead of instantiating your cache `LOGGER = Logger.new`, use `Logger.instance`. It will return a thread-local instance.

``` ruby
Thread.new do
	Logger.instance
	# => #<Logger:0x000055a14ec6be80>
end

Thread.new do
	Logger.instance
	# => #<Logger:0x000055a14ec597d0>
end
```

In cases where you have job per fiber or request per fiber, you might want to collect all log output for a specific fiber, you can do the following:

``` ruby
Logger.instance
# => #<Logger:0x000055a14ec6be80>

Fiber.new do
	Logger.instance = Logger.new
	# => #<Logger:0x000055a14ec597d0>
end
```

## Sharing

You can assign to the fiber-local instance which inherited to child fibers and threads.

``` ruby
Logger.instance
# => #<Logger:0x000055a14ec6be80>

Fiber.new do
	Logger.instance = Logger.new
	# => #<Logger:0x000055a14ec597d0>
	
	Fiber.new do
		Logger.instance
		# => #<Logger:0x000055a14ec597d0>
	end.resume
	
	Thread.new do
		Logger.instance
		# => #<Logger:0x000055a14ec597d0>
	end.join
end.resume
```

You can use this to control per-request or per-operation state.

### Thread Safety

`Fiber::Local` is thread-safe. It uses a thread-local variable to store the fiber-local instance. However, you must also ensure that the instance you are storing is thread-safe, if you expect to share it across threads.
