class CreateCourses < ActiveRecord::Migration[8.0]
  def up
    create_table :courses do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :courses
  end
end
