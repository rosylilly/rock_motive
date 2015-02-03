<%- module_namespacing do -%>
  <%- if parent_class_name.present? -%>
class <%= class_name %>Context < <%= parent_class_name %>
  <%- else -%>
class <%= class_name %>
  <%- end -%>

  def execute()
  end
end
<% end -%>
