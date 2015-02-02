require 'benchmark'
require 'ruby-prof'
require 'rock_motive/interaction'

class PORO
  def say
    :yes
  end
end

module Shopper
  def say
    :no
  end
end

module Seller
  def say
    :no
  end
end

class Deal
  def interact(shopper, seller)
    shopper.say
    seller.say
  end
end

class DealInteraction < RockMotive::Interaction
  def interact(shopper, seller)
    shopper.say
    seller.say
  end
end

NUM_INTERATIONS = 1000000

Benchmark.bmbm do |x|
  x.report('PORO') { NUM_INTERATIONS.times { Deal.new.interact(PORO.new, PORO.new) } }
  x.report('RockMotive') { NUM_INTERATIONS.times { DealInteraction.new.interact(PORO.new, PORO.new) } }
end
