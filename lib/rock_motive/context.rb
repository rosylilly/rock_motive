require 'uninclude'
require 'active_support/inflector'
require 'active_support/core_ext/module/aliasing'
require 'rock_motive/resolver'

class RockMotive::Context
  class << self
    def execute(*args)
      new.execute(*args)
    end

    def scopes
      @scopes ||= ::RockMotive::Resolver.scopes(self)
    end

    def scope(*nss)
      nss.each do |ns|
        scopes.push(ns.to_s.classify)
      end
    end

    def actors
      @actors ||= []
    end

    private

    def method_added(method_name)
      return if method_name != :execute || @__override_now

      for_args, for_keywords = *roles_by_execute_method
      return if for_args.reject(&:nil?).empty? && for_keywords.values.reject(&:nil?).empty?

      override_execute_method(for_args, for_keywords)

      @__override_now = true
      alias_method_chain :execute, :roles
      @__override_now = false
    end

    def execute_method
      instance_method(:execute)
    end

    def roles_by_execute_method
      @actors = []

      for_args = []
      for_keywords = {}

      execute_method.parameters.each do |param|
        type, name = *param

        @actors << name.to_s.to_sym

        case type
        when :req, :opt
          for_args << ::RockMotive::Resolver.roles(name, scopes)
        when :keyreq, :key
          for_keywords[name] = ::RockMotive::Resolver.roles(name, scopes)
        end
      end

      [for_args, for_keywords]
    end

    def override_execute_method(for_args, for_keywords)
      method_definition = ['def execute_with_roles(*args, &block)']
      method_definition << 'kv = args.last'
      method_definition << for_args_definition(for_args, :extend)
      method_definition << for_keywords_definition(for_keywords, :extend)
      method_definition << 'ret = execute_without_roles(*args, &block)'
      method_definition << for_args_definition(for_args, :unextend)
      method_definition << for_keywords_definition(for_keywords, :unextend)
      method_definition << 'ret'
      method_definition << 'end'

      class_eval(method_definition.join("\n"))
    end

    def for_args_definition(for_args, method_name)
      defs = for_args.map.with_index do |roles, n|
        if roles.empty?
          ''
        else
          roles.map { |role| "args[#{n}].#{method_name}(#{role.name})" }
        end
      end

      defs.flatten.reject(&:empty?).join('; ')
    end

    def for_keywords_definition(for_keywords, method_name)
      defs = for_keywords.map do |key, roles|
        if roles.empty?
          ''
        else
          roles.map { |role| "kv[:#{key}].#{method_name}(#{role.name})" }
        end
      end

      defs.flatten.reject(&:empty?).join('; ')
    end
  end
end
