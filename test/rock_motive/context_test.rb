require 'test_helper'
require 'rock_motive/context'

class RockMotive::ContextTest < ActiveSupport::TestCase
  test '.execute' do
    assert { context_class.execute }
  end

  test '.execute with override' do
    assert { context_class_with_override_execute.execute }
  end

  test '.scopes' do
    context_class.scope 'hoge'

    assert { RockMotive::Context.scopes.length == 3 }
    assert { context_class.scopes.length == 2 }
  end

  test '.actors' do
    assert { context_class.actors == [] }
    assert { context_class_with_role.actors == [:pigeon] }
  end

  test '#execute with extend' do
    bird = Bird.new(name: 'hato')

    assert { context_class_with_role.execute(bird) == 'hato!' }
  end

  test '#execute with keyword argument' do
    bird = Bird.new(name: 'hato')

    assert { context_class_with_keyword.execute(bird, pigeon: bird) == 'hato!' }
  end

  test '#execute with unextended' do
    bird = Bird.new(name: 'hato')

    context_class_with_role.execute(bird)

    assert { bird.singleton_class.ancestors.exclude?(PigeonRole) }

    context_class_with_keyword.execute(bird, pigeon: bird)

    assert { bird.singleton_class.ancestors.exclude?(PigeonRole) }
  end

  test '#execute with scope' do
    bird = Bird.new(name: 'hato')

    context_class_with_scope.execute(bird)

    assert { bird.singleton_class.ancestors.exclude?(Fake::PigeonRole) }
  end

  private

  def context_class
    @context_class ||= Class.new(RockMotive::Context) do
      def execute
        true
      end
    end
  end

  def context_class_with_role
    @context_class_with_role ||= Class.new(RockMotive::Context) do
      def execute(pigeon)
        pigeon.chirp
      end
    end
  end

  def context_class_with_override_execute
    @context_class_with_override_execute ||= Class.new(RockMotive::Context) do
      def self.execute
        true
      end
    end
  end

  def context_class_with_scope
    @context_class_with_scope ||= Class.new(RockMotive::Context) do
      scope 'fake'

      def execute(pigeon)
        pigeon.fly
      end
    end
  end

  # rubocop:disable all
  def context_class_with_keyword
    @context_class_with_keyword ||= Class.new(RockMotive::Context) do
      def execute(hato, msg = '', *args, pigeon:, penguin: nil, **opt)
        pigeon.chirp
      end
    end
  end
  # rubocop:enable all
end
