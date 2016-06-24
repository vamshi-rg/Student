class CollegesController < ApplicationController

	def index
		@colleges = College.all
	end

	def show

	end

	def new
		@college = College.new
	end

	def edit
		@college = College.find(params[:id])
	end

	def create
		@college = College.new(:name => params[:name], :year => params[:year])
		
		if @college.save
	      redirect_to action: :index
	    else
	      render :new
	    end 
		@colleges = College.all
	end

	def update
		@college = College.find(params[:id])
		if @college.update_attributes(:name => params[:college][:name], :year => params[:college][:year])
			redirect_to action: :show
		else
			render :edit
		end
	end

	def destroy
  		@college = College.find(params[:id])
  		@college.destroy
  		redirect_to action: :index
  	end

  	def results
  		Rails.logger.debug "Inside results method"
  		result = College.pluck(:name)
  		Rails.logger.debug "#{result}"
  		Rails.logger.debug "#{params[:Search].to_s}"
  		len = result.size
  		search_array = []
  		for i in 0..len-1
  			Rails.logger.debug "Inside for loop"
  			result[i].downcase!
  			if result[i].include? params[:Search]
   				search_array.push(result[i])
			end
		end
		@array = search_array
  	end

  	def search
  		college = College.find(params[:id])
  		Rails.logger.error "params: " + params.inspect
  		@students = college.students
  		Rails.logger.error "students: " + @Student.inspect
  	end

end
