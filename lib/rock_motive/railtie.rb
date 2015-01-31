require 'rails/railtie'

class RockMotive::Railtie < ::Rails::Railtie
  initializer 'rock_motive.paths' do |app|
    app.paths.add('app/interactions', eager_load: true)
    app.paths.add('app/roles', eager_load: true)
  end

  initializer 'rock_motive.interaction' do
    require 'rock_motive/interaction'
  end
end
