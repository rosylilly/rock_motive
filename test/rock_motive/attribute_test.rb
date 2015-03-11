require 'test_helper'
require 'rock_motive/attribute'

module AttrRole
  def foo
    true
  end
end

class RockMotive::AttributeTest < ActiveSupport::TestCase
  test '.attr_with_roles' do
    klass.class_eval do
      attr_with_roles :pigeon
    end

    instance.pigeon = Bird.new

    assert { instance.pigeon.chirp }
  end

  test '.attr_with_roles with override' do
    klass.class_eval do
      attr_with_roles :attr
    end

    instance.attr = Object.new

    assert { instance.attr.foo }
  end

  private

  def klass
    @klass ||= Class.new do
      include RockMotive::Attribute

      def initialize
        @hash = {}
      end

      def attr
        @hash[:attr]
      end

      def attr=(obj)
        @hash[:attr] = obj
      end
    end
  end

  def instance
    @instance ||= klass.new
  end
end
