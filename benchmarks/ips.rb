require 'benchmark'
require 'benchmark/ips'
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

Benchmark.ips do |x|
  x.report('PORO') { Deal.new.interact(PORO.new, PORO.new) }
  x.report('RockMotive') { DealInteraction.new.interact(PORO.new, PORO.new) }
end
