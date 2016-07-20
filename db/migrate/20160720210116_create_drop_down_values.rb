class CreateDropDownValues < ActiveRecord::Migration[5.0]
  def change
    create_table :drop_down_values do |t|
      t.string :value, :null => false

      # we use index: false here because we create a unique index with user_id, value instead
      t.references :user, index: false, :null => false
      t.references :custom_field, index: true, :null => false
      t.timestamps
    end

    add_index :drop_down_values, [:user_id, :value], :unique => true

    add_foreign_key :drop_down_values, :users
    add_foreign_key :drop_down_values, :custom_fields
  end
end
