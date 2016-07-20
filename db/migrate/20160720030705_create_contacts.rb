class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.references :user, index: true, :null => false
      t.timestamps
    end

    add_foreign_key :contacts, :users
  end
end
