require 'uninclude'
require 'active_support/inflector'
require 'active_support/core_ext/module/aliasing'
require 'rock_motive'

class RockMotive::Interaction
  class << self
    def interact(*args)
      new.interact(*args)
    end

    def inherited(klass)
      class << klass
        def method_added(method_name)
          return if method_name != :interact || @__override_now

          roles = roles_by_interact_method
          return if roles.empty?

          override_interact_method(roles)
        end
      end
    end

    private

    def interact_method
      instance_method(:interact)
    rescue NameError
      nil
    end

    def roles_by_interact_method
      return [] unless interact_method

      interact_method.parameters.map do |param|
        get_role_by_name(param.last)
      end
    end

    def get_role_by_name(name)
      role_name = name.to_s.classify

      const = role_name.safe_constantize || "#{role_name}Role".safe_constantize

      (const.is_a?(Module) && !const.is_a?(Class)) ? const : nil
    end

    def override_interact_method(roles)
      define_method(:interact_with_roles) do |*args|
        args.each_with_index { |arg, n| role = roles[n]; arg && role && arg.extend(role) }

        ret = interact_without_roles(*args)

        args.each_with_index { |arg, n| role = roles[n]; arg && role && arg.unextend(role) }

        ret
      end

      @__override_now = true
      alias_method_chain :interact, :roles
      @__override_now = false
    end
  end
end
