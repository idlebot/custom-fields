class CreateCustomFields < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_fields do |t|
      t.string :field_name, :null => false
      t.string :type, :null => false
      t.references :user, index: true, :null => false
      t.timestamps
    end

    add_foreign_key :custom_fields, :users
  end
end
