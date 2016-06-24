class RemoveCollgeIdCollege < ActiveRecord::Migration
  def change
  	remove_column :colleges, :college_id
  end
end
