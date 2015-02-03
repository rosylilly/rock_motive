require 'uninclude'
require 'active_support/inflector'
require 'active_support/core_ext/module/aliasing'
require 'rock_motive'

class RockMotive::Context
  class << self
    def execute(*args)
      new.execute(*args)
    end

    def inherited(klass)
      class << klass
        def method_added(method_name)
          return if method_name != :execute || @__override_now

          for_args, for_keywords = *roles_by_execute_method
          return if for_args.reject(&:nil?).empty? && for_keywords.empty?

          override_execute_method(for_args, for_keywords)
        end
      end
    end

    private

    def execute_method
      instance_method(:execute)
    end

    def roles_by_execute_method
      for_args = []
      for_keywords = {}

      execute_method.parameters.each do |param|
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

    # rubocop:disable all
    def override_execute_method(for_args, for_keywords)
      class_eval(<<-EOM)
        def execute_with_roles(*args)
          #{for_keywords.empty? ? '' : 'kv = args.last'}
          #{for_args.map.with_index { |role, n| !role ? '' : "args[#{n}].extend(#{role.name})" }.join('; ') }
          #{for_keywords.map { |n, r| !r ? '' : "kv[:#{n}].extend(#{r.name})" }.join('; ') }

          ret = execute_without_roles(*args)

          #{for_args.map.with_index { |role, n| !role ? '' : "args[#{n}].unextend(#{role.name})" }.join('; ') }
          #{for_keywords.map { |n, r| !r ? '' : "kv[:#{n}].unextend(#{r.name})" }.join('; ') }

          ret
        end
      EOM

      @__override_now = true
      alias_method_chain :execute, :roles
      @__override_now = false
    end
  end
  # rubocop:enable all
end
