<%- module_namespacing do -%>
  <%- if parent_class_name.present? -%>
class <%= class_name %>Interaction < <%= parent_class_name %>
  <%- else -%>
class <%= class_name %>
  <%- end -%>

  def interact()
  end
end
<% end -%>
