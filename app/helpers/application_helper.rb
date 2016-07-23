# General application helpers
module ApplicationHelper
  # Credit: rails casts episodes 196 and 197
  def link_to_remove_fields(f, name)
    f.hidden_field(:_destroy) + link_to(name, "#", class: "remove-fields btn btn-default")
  end

  def link_to_add_fields(f, name, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add-fields btn btn-default add-field-button", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
