namespace :update_ex_id do
	desc "Adds one month to the Look Subscription"

 	task :creating_extended_id => :environment do
 		Rails.logger.debug "Inside rake task"
	    stu = Student.all
	    Rails.logger.debug "#{stu.inspect}"
	    stu.each do |s|
	    	Rails.logger.debug "Inside loop"
	    	Rails.logger.debug "#{s.inspect}"
	    	
	    	s[:extended_sid] = s.updating_extended_sid
	    	s.save
    	end
    end
end
