module TestUnit
  class InteractionGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_test_file
      template 'interaction_test.rb', File.join('test/interactions', class_path, "#{singular_name}_interaction_test.rb")
    end
  end
end
