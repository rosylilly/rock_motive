module TestUnit
  class ContextGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_test_file
      template 'context_test.rb', File.join('test/contexts', class_path, "#{singular_name}_context_test.rb")
    end
  end
end
