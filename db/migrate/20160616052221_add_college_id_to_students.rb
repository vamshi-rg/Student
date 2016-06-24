class AddCollegeIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :college_id, :string
  end
end
