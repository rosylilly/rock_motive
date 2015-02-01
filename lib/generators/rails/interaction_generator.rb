module Rails
  module Generators
    class InteractionGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Interaction'

      class_option :parent, type: :string, desc: 'The parent class for the generated interaction'

      def create_interaction_file
        template 'interaction.rb', File.join('app/interactions', class_path, "#{file_name}_interaction.rb")
      end

      hook_for :test_framework

      private

      def parent_class_name
        options.fetch('parent') do
          begin
            require 'application_interaction'
            ApplicationInteraction
          rescue LoadError
            'RockMotive::Interaction'
          end
        end
      end
    end
  end
end
