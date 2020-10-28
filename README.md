# Fiber::Local

A module to simplify fiber-local state.

[![Development Status](https://github.com/socketry/fiber-local/workflows/Development/badge.svg)](https://github.com/socketry/fiber-local/actions?workflow=Development)

## Features

  - Easily access fiber-local state from a fiber.
  - Default to shared thread-local state.

## Installation

``` bash
$ bundle add fiber-local
```

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

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

## See Also

  - [thread-local](https://github.com/socketry/thread-local) — Strictly thread-local variables.

## License

Released under the MIT license.

Copyright, 2020, by [Samuel G. D. Williams](https://www.codeotaku.com).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
