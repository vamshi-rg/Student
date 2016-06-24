class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :student_id
      t.string :dept
      t.integer :maths
      t.integer :physics
      t.integer :chemistry
      t.integer :year

      t.timestamps
    end
  end
end
