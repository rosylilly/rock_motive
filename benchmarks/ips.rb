require 'benchmark'
require 'benchmark/ips'
require 'ruby-prof'
require 'rock_motive/context'
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
  def execute(shopper, seller)
    shopper.say
    seller.say
  end
end

class DealDelegator
  def execute(shopper, seller)
    ShopperDelegator.new(shopper).say
    SellerDelegator.new(seller).say
  end
end

class DealContext < RockMotive::Context
  def execute(shopper, seller)
    shopper.say
    seller.say
  end
end

Benchmark.ips do |x|
  x.report('PORO') { Deal.new.execute(PORO.new, PORO.new) }
  x.report('Delegator') { DealDelegator.new.execute(PORO.new, PORO.new) }
  x.report('RockMotive') { DealContext.new.execute(PORO.new, PORO.new) }
end
