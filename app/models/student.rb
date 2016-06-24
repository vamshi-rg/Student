class Student < ActiveRecord::Base
  	attr_accessible :chemistry, :dept, :maths, :physics, :student_id, :year, :college_id, :extended_sid
  	validates :maths, :physics, :chemistry, allow_blank: true, :inclusion => {:in => 0..100, :message => "Incorrect Range please enter valid details" }
  	validates :dept, :college_id, :student_id, :year, :presence => true
  	validates :year, :inclusion => {:in => 1900..2016 , :message => "Incorrect Range please enter valid details"}
  	belongs_to :college 

  	before_create :updating_extended_sid
  	
    def updating_extended_sid
            sid = self.id*1
        	extended_id = sid.to_s<<"_"<<College.find(self.college_id)[:name][0,2]<<"_"<<self.college_id.to_s
        	self.extended_sid = extended_id
    end
end
