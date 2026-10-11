class CreateTutors < ActiveRecord::Migration[8.0]
  def up
    create_table :tutors do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tutors, "LOWER(email)",
              unique: true,
              name: "index_tutors_on_lower_email"
  end

  def down
    drop_table :tutors
  end
end
