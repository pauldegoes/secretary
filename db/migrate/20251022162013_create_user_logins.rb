class CreateUserLogins < ActiveRecord::Migration[7.1]
  def change
    create_table :user_logins do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.text :user_agent
      t.datetime :signed_in_at, null: false

      t.timestamps
    end

    add_index :user_logins, :signed_in_at
    add_index :user_logins, [:user_id, :signed_in_at]
  end
end
