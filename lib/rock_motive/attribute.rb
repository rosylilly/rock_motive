require 'active_support/concern'
require 'active_support/core_ext/module/aliasing'
require 'rock_motive/resolver'

module RockMotive::Attribute
  extend ActiveSupport::Concern

  module ClassMethods
    def attr_with_roles(*symbols)
      symbols.each do |symbol|
        roles = ::RockMotive::Resolver.roles(symbol, ::RockMotive::Resolver.scopes(self))
        chain = instance_methods.include?("#{symbol}=".to_sym)

        class_eval(<<-EOC)
        def #{symbol}#{chain ? '_with_roles' : ''}=(obj)
          #{roles.map { |role| "obj.extend(#{role.name})" }.join('; ')}
          #{chain ? "__send__(:#{symbol}_without_roles=, obj)" : "@#{symbol} = obj"}
        end
        #{chain ? "alias_method_chain :#{symbol}=, :roles" : ''}
        attr_reader(:#{symbol}) unless instance_methods.include?(:#{symbol})
        EOC
      end
    end
  end
end
