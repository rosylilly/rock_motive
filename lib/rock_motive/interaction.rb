require 'rock_motive'

class RockMotive::Interaction
  class << self
    def interact(*args)
      new(*args).interact(*args)
    end

    def inherited(klass)
      class << klass
        def method_added(method_name)
          return if method_name != :interact || @__chain

          interact_method = instance_method(:interact)
          roles = interact_method.parameters.map(&:last).map do |role|
            role_name = role.to_s.classify
            mod = role_name.safe_constantize || "#{role_name}Role".safe_constantize
            mod.is_a?(Module) ? mod : nil
          end

          define_method(:interact_with_roles) do |*args|
            args.zip(roles).each do |arg, role|
              arg.extend(role) if arg && role
            end

            interact_without_roles(*args)

            args.zip(roles).each do |arg, role|
              arg.unextend(role) if arg && role
            end
          end
          @__chain = true
          alias_method_chain :interact, :roles
          @__chain = false
        rescue NameError
        end
      end
    end
  end

  def initialize(*)
  end
end
