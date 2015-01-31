require 'rails/railtie'

class RockMotive::Railtie < ::Rails::Railtie
  initializer 'rock_motive.interaction' do
    require 'rock_motive/interaction'
  end
end
