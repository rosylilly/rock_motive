require 'test_helper'
require 'rock_motive/resolver'

class RockMotive::ResolverTest < ActiveSupport::TestCase
  test '.roles' do
    assert { RockMotive::Resolver.roles(:pigeon) == [PigeonRole] }
    assert { RockMotive::Resolver.roles(:pigeon, ['Fake']) == [Fake::PigeonRole] }
  end
end
