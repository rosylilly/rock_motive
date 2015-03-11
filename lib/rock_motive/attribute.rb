require 'active_support/concern'
require 'active_support/core_ext/module/aliasing'
require 'rock_motive/resolver'

module RockMotive::Attribute
  extend ActiveSupport::Concern

  module ClassMethods
    def attr_with_roles(*symbols)
      symbols.each do |symbol|
        roles = ::RockMotive::Resolver.roles(symbol, ::RockMotive::Resolver.scopes(self))

        class_eval(<<-EOC)
        if instance_methods.include?(:#{symbol}=)
          def #{symbol}_with_roles=(obj)
            #{roles.map{|role| "obj.extend(#{role.name})" }.join('; ')}
            __send__(:#{symbol}_without_roles=, obj)
          end
          alias_method_chain :#{symbol}=, :roles
        else
          def #{symbol}=(obj)
            #{roles.map{|role| "obj.extend(#{role.name})" }.join('; ')}
            @#{symbol} = obj
          end
        end
        attr_reader(:#{symbol}) unless instance_methods.include?(:#{symbol})
        EOC
      end
    end
  end
end
