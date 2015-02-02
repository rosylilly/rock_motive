require 'ruby-prof'
require 'rock_motive/interaction'

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

class ProfileInteraction < RockMotive::Interaction
  def interact(profiler, foo)
    profiler.baz
    foo.bar
  end
end

NUM_ITERATION = 10000

RubyProf.start

NUM_ITERATION.times do
  foo = Foo.new
  foo.extend(Profiler)
  foo.baz
  foo.unextend(Profiler)
  foo.bar
end

result = RubyProf.stop
printer = RubyProf::CallTreePrinter.new(result)
open('tmp/callgrind.profile', 'w') do |f|
  printer.print(f)
end
