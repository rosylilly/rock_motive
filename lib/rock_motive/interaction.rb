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

          for_args, for_keywords = *roles_by_interact_method
          return if for_args.empty? && for_keywords.empty?

          override_interact_method(for_args, for_keywords)
        end
      end
    end

    private

    def interact_method
      instance_method(:interact)
    end

    def roles_by_interact_method
      for_args = []
      for_keywords = {}

      interact_method.parameters.each do |param|
        type, name = *param
        case type
        when :req, :opt
          for_args << get_role_by_name(name)
        when :keyreq, :key
          for_keywords[name] = get_role_by_name(name)
        end
      end

      [for_args, for_keywords]
    end

    def get_role_by_name(name)
      role_name = name.to_s.classify

      const = role_name.safe_constantize || "#{role_name}Role".safe_constantize

      (const.is_a?(Module) && !const.is_a?(Class)) ? const : nil
    end

    def override_interact_method(for_args, for_keywords)
      define_method(:interact_with_roles) do |*args|
        keyword_args = for_keywords.empty? ? {} : args.last

        extend_roles_for_args(args, for_args)
        extend_roles_for_keywords(keyword_args, for_keywords)

        ret = interact_without_roles(*args)

        unextend_roles_for_args(args, for_args)
        unextend_roles_for_keywords(keyword_args, for_keywords)

        ret
      end

      @__override_now = true
      alias_method_chain :interact, :roles
      @__override_now = false
    end
  end

  private

  def extend_roles_for_args(args, roles)
    args.each_with_index do |arg, n|
      role = roles[n]

      arg.extend(role) if arg && role
    end
  end

  def unextend_roles_for_args(args, roles)
    args.each_with_index do |arg, n|
      role = roles[n]

      arg.extend(role) if arg && role
    end
  end

  def extend_roles_for_keywords(args, roles)
    args.each_pair do |key, arg|
      role = roles[key]

      arg.extend(role) if arg && role
    end
  end

  def unextend_roles_for_keywords(args, roles)
    args.each_pair do |key, arg|
      role = roles[key]

      arg.unextend(role) if arg && role
    end
  end
end
