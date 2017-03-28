class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    add_reference :sources, :project, index: true
    add_reference :tags, :project, index: true

    create_join_table :projects, :users, table_name: :participations do |t|
      t.index :project_id
      t.index :user_id
    end

    reversible do |dir|
      dir.up do
        project = Project.new({
          name: 'Initial Project',
          description: 'All work that was created before the system introduced a project scope, is now attached to this project.'
          })
        project.source_ids = Source.all.pluck(:id)
        project.tag_ids = Tag.all.pluck(:id)
        project.user_ids = User.all.pluck(:id)
        project.save!
      end
    end
  end
end
