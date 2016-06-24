class AddCollegeIdToCollege < ActiveRecord::Migration
  def change
    add_column :colleges, :college_id, :string
  end
end
