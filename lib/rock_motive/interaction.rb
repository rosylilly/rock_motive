require 'uninclude'
require 'rock_motive'

class RockMotive::Interaction
  class << self
    def interact(*args)
      new(*args).interact(*args)
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

      interact_method.parameters.map(&:last).map do |role|
        role_name = role.to_s.classify
        mod = role_name.safe_constantize || "#{role_name}Role".safe_constantize
        mod.is_a?(Module) ? mod : nil
      end
    end

    def override_interact_method(roles)
      define_method(:interact_with_roles) do |*args|
        args.zip(roles).each { |arg, role| arg && role && arg.extend(role) }

        ret = interact_without_roles(*args)

        args.zip(roles).each { |arg, role| arg && role && arg.unextend(role) }

        ret
      end

      @__override_now = true
      alias_method_chain :interact, :roles
      @__override_now = false
    end
  end

  def initialize(*)
  end
end
