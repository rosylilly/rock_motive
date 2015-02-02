require 'test_helper'
require 'rock_motive/interaction'

class RockMotive::InteractionTest < ActiveSupport::TestCase
  test '.interact' do
    assert { interaction_class.interact }
  end

  test '.interact with override' do
    assert { interaction_class_with_override_interact.interact }
  end

  test '#interact with extend' do
    bird = Bird.new(name: 'hato')

    assert { interaction_class_with_role.interact(bird) == 'hato!' }
  end

  test '#interact with keyword argument' do
    bird = Bird.new(name: 'hato')

    assert { interaction_class_with_keyword.interact(bird, pigeon: bird) == 'hato!' }
  end

  test '#interact with unextended' do
    bird = Bird.new(name: 'hato')

    interaction_class_with_role.interact(bird)

    assert { bird.singleton_class.ancestors.exclude?(PigeonRole) }

    interaction_class_with_keyword.interact(bird, pigeon: bird)

    assert { bird.singleton_class.ancestors.exclude?(PigeonRole) }
  end

  private

  def interaction_class
    @interaction_class ||= Class.new(RockMotive::Interaction) do
      def interact
        true
      end
    end
  end

  def interaction_class_with_role
    @interaction_class_with_role ||= Class.new(RockMotive::Interaction) do
      def interact(pigeon)
        pigeon.chirp
      end
    end
  end

  def interaction_class_with_override_interact
    @interaction_class_with_override_interact ||= Class.new(RockMotive::Interaction) do
      def self.interact
        true
      end
    end
  end

  # rubocop:disable all
  def interaction_class_with_keyword
    @interaction_class_with_keyword ||= Class.new(RockMotive::Interaction) do
      def interact(hato, msg = '', *args, pigeon:, penguin: nil, **opt)
        pigeon.chirp
      end
    end
  end
  # rubocop:enable all
end
