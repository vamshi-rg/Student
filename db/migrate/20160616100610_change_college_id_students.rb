class ChangeCollegeIdStudents < ActiveRecord::Migration
  def up
  	change_column :students, :college_id, :integer
  end

  def down
  	change_column :students, :college_id, :string
  end
end
