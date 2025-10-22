class CreateProjectTags < ActiveRecord::Migration[7.1]
  def change
    create_table :project_tags do |t|
      t.references :project, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :project_tags, [:project_id, :tag_id], unique: true
  end
end
