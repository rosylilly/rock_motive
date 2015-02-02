require 'benchmark'
require 'benchmark/ips'
require 'ruby-prof'
require 'rock_motive/interaction'
require 'delegate'

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

class ShopperDelegator < SimpleDelegator
  def say
    :no
  end
end

class SellerDelegator < SimpleDelegator
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

class DealDelegator
  def interact(shopper, seller)
    ShopperDelegator.new(shopper).say
    SellerDelegator.new(seller).say
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
  x.report('Delegator') { DealDelegator.new.interact(PORO.new, PORO.new) }
  x.report('RockMotive') { DealInteraction.new.interact(PORO.new, PORO.new) }
end
