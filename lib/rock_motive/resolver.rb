require 'rock_motive'

module RockMotive::Resolver
  class << self
    def roles(name, scopes = [''])
      role_name = name.to_s.classify

      consts = scopes.map do |ns|
        name = "#{ns}::#{role_name}"
        const = (name.safe_constantize || "#{name}Role".safe_constantize)

        (const.is_a?(Module) && !const.is_a?(Class)) ? const : nil
      end

      consts.reject(&:nil?)
    end

    def scopes(mod)
      mod.name.to_s.split('::').inject(['']) do |scopes, ns|
        scopes + ["#{scopes.last}::#{ns}"]
      end
    end
  end
end
