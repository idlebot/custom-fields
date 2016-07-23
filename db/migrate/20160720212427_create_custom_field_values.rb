class CreateCustomFieldValues < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_field_values do |t|
      t.string :value, :null => true
      t.string :type, :null => false

      # we use index: false here because we create a unique index with contact_id, custom_field_id instead
      t.references :contact, index: false, :null => false
      t.references :custom_field, index: true, :null => false

      # null: true because only field values of type DropDownCustomFieldValue has a drop_down_value_id
      t.references :drop_down_value, index: true, :null => true
      t.timestamps
    end

    add_index :custom_field_values, [:contact_id, :custom_field_id], :unique => true

    add_foreign_key :custom_field_values, :contacts
    add_foreign_key :custom_field_values, :custom_fields
    add_foreign_key :custom_field_values, :drop_down_values
  end
end
