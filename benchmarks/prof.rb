require 'ruby-prof'
require 'rock_motive/context'

module Profiler
  def baz
    'string'
  end
end

class Foo
  def bar
    'string'
  end
end

class ProfileContext < RockMotive::Context
  def execute(profiler, foo)
    profiler.baz
    foo.bar
  end
end

NUM_ITERATION = 10_000

RubyProf.start

NUM_ITERATION.times do
  ProfileContext.execute(Foo.new, Foo.new)
end

result = RubyProf.stop
printer = RubyProf::CallTreePrinter.new(result)
open('tmp/callgrind.profile', 'w') do |f|
  printer.print(f)
end
