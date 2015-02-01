module TestUnit
  class RoleGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_test_file
      template 'role_test.rb', File.join('test/roles', class_path, "#{singular_name}_role_test.rb")
    end
  end
end
