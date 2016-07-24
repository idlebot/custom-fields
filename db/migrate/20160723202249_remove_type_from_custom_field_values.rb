class RemoveTypeFromCustomFieldValues < ActiveRecord::Migration[5.0]
  def change
    remove_column :custom_field_values, :type
  end
end
