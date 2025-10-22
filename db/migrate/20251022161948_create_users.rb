class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [:provider, :uid], unique: true
    add_index :users, :username
  end
end
