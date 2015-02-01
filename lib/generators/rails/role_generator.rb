module Rails
  module Generators
    class RoleGenerator < NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Role'

      def create_role_file
        template 'role.rb', File.join('app/roles', class_path, "#{file_name}_role.rb")
      end

      hook_for :test_framework
    end
  end
end
