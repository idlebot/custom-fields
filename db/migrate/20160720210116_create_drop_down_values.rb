class CreateDropDownValues < ActiveRecord::Migration[5.0]
  def change
    create_table :drop_down_values do |t|
      t.string :value, :null => false

      t.references :custom_field, index: true, :null => false
      t.timestamps
    end

    add_foreign_key :drop_down_values, :custom_fields
  end
end
