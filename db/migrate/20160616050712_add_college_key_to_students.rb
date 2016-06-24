class AddCollegeKeyToStudents < ActiveRecord::Migration
  	def change
		def self.up
	    	add_column :students, :collegeid, :integer, :unique => true
	  	end
	end
end
