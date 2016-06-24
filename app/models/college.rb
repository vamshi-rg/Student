class College < ActiveRecord::Base
  	attr_accessible :name, :year
  	 
  	validates :name, :length => {:maximum => 25}, :presence => true
  	validates :year, :length => {:minimum => 4}, :presence => true
  	has_many :students
  	before_update :update_extended_id
  	protected
  	def update_extended_id
  	Rails.logger.debug "Inside College update_extended_id method"
  		if self.name_changed?
  			Rails.logger.debug "Inside if loop"
  			Rails.logger.debug "#{name.inspect}"
  			student = Student.find_all_by_college_id(self.id)
  			Rails.logger.debug "#{student.inspect}"
  			student.each do |s|
  				s.extended_sid = s[:id].to_s<<"_"<<self.name[0,2]<<"_"<<(self.id).to_s
  				s.save
  			end
  		end
  	end
end
