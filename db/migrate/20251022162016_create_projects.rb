class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.datetime :target_date
      t.string :owner, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :projects, :name
    add_index :projects, :target_date
    add_index :projects, [:user_id, :name]
  end
end
