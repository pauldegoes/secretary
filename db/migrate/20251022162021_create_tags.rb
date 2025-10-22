class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :namespace, null: false

      t.timestamps
    end

    add_index :tags, [:namespace, :name], unique: true
    add_index :tags, :namespace
  end
end
