class StudentsController < ApplicationController
	def index
		@students= Student.all
	end

	def show
		@s = Student.find(params[:id])
		@params = params
		
		respond_to do |format|
			format.json do
			    render json: @s.to_json
			end

			format.html do
			end
		end
	end

	def new
		@input_params = Student.new

  	end

  	def edit
  		@student = Student.find(params[:id])

  		respond_to do |format|
  			format.json do
  				render json: @student.to_json
  			end
  			format.html do
  			end
  		end
  	end

  	def update
  		Rails.logger.debug "Inside Update Method"
  		@student = Student.find(params[:id])
  		Rails.logger.debug "#{params}"
		Rails.logger.debug "updating the attributes of student :#{params.inspect}"
		
		Rails.logger.debug "inspecting dept of student :#{@student.attributes["dept"].inspect}"
		@student.update_attributes(:student_id => params[:student][:student_id], :dept => params[:student][:dept], :maths => params[:student][:maths], :physics => params[:student][:physics], :chemistry => params[:student][:chemistry], :year => params[:student][:year], :college_id => params[:student][:college_id])
		logger.debug "updating the attributes of student :#{@student.attributes.inspect}"
		if @student.save	
			redirect_to action: :show
		else
			render :edit
		end
  	end

  	def create
		@student = Student.new(:student_id => params[:student_id], :dept => params[:dept], :maths => params[:maths], :physics => params[:physics],:chemistry => params[:chemistry], :year => params[:year],:college_id => params[:college_id], :extended_sid => params[:extended_sid])
		respond_to do |format|
  			format.json do
  				render json: @student.to_json
  			end
  			format.html do
  			end
  		end

		if @student.save
	      redirect_to action: :index
	    else
	      render :new
	    end 
		@students = Student.all
  	end

  	def destroy
  		@student = Student.find(params[:id])
  		@student.destroy
  		redirect_to action: :index
  	end

  	def do_query
 	end

  	def do_queries
  		Rails.logger.debug "inside do_queries"
  		unless params["group"].nil?
  		
	  		student_hash = Student.all
	  		grouped_hash= group_by(student_hash)
	  		@@get_compare = params["compare"]
	  		@@get_total = params["total"]
	  		@@final_sorted_hash = sort_by(grouped_hash)

	  		if (params[compare] == "1")
	  			compare
	  		end
	  		if (params[total] == "1")
	  			total
	  		end

	  		redirect_to results_students_url
	  	end

  	end

  	def total
  		Rails.logger.debug "Inside Total"
  		get_show_total = params["total"]
		if(get_show_total == "1")
		# checking the user input and looping according to it
			student_hash = Student.all
			grouped_show_total_hash = student_hash.group_by { |h| h[:year] } # grouping student hash by year and storing in grouped_show_total_hash
			Rails.logger.debug "#{grouped_show_total_hash}"
			
			 # printing the head row of the table to show the sorted hash
			totalhash = {}
			grouped_show_total_hash.each_key { |key| 
				len = grouped_show_total_hash[key].length
				Rails.logger.debug "#{len.inspect}"
				maths_tot = 0
				physics_tot = 0
				chemistry_tot = 0
				arr = []
				for i in 0..len-1
					Rails.logger.debug "Inside for loop"
					maths_tot = maths_tot + grouped_show_total_hash[key][i][:maths]             # calculating the total maths marks
					physics_tot = physics_tot + grouped_show_total_hash[key][i][:physics]		# calculating the total physics marks
					chemistry_tot = chemistry_tot + grouped_show_total_hash[key][i][:chemistry]	# calculating the total chemistry marks
					Rails.logger.debug "#{maths_tot}"
					Rails.logger.debug "#{physics_tot}"
					Rails.logger.debug "#{physics_tot}"
				end
				
				arr.push({:year => key, :mathstot => maths_tot, :physicstot => physics_tot, :chemistrytot => chemistry_tot })
				totalhash[key] = arr
				 # printing the values in table format
				
			}
			Rails.logger.debug "#{totalhash}"
			@@total_hash = totalhash
				
		else()
			puts "Show Total =false"
		end

  	end
	
  	def compare
  		student_hash = Student.all
  		#Rails.logger.debug "#{student_hash}"
  		get_compare = params["compare"]
  		
			# taking user inputs for current year and past year
			
		get_current_year = 2016

		get_past_year = 2015

			# grouping the student hash by year
		grouped_hash = student_hash.group_by { |h| h[:year] }
			#Rails.logger.debug "#{grouped_hash}"
			# defining current year hash and past year hash separately
		current_hash = grouped_hash[get_current_year]
		Rails.logger.debug "current hash: "
		Rails.logger.debug "#{current_hash}"
		past_hash = grouped_hash[get_past_year]
		if(get_compare == "student_id")
			# grouping the current hash and past hash with year	 according to id   
			Rails.logger.debug "#{past_hash}" 
			Rails.logger.debug "Inside if condition on compare on with student_id"
			Rails.logger.debug "#{params["compareon"]}"
			group_current_hash = current_hash.group_by {|i| i[:student_id]}
			Rails.logger.debug "#{group_current_hash}"
			group_past_hash = past_hash.group_by {|j| j[:student_id]}
			Rails.logger.debug "#{group_past_hash}"
			
			# defining the final hash to which all the current , past, change hashes have to be pushed	
			final_hash = {}
					# looping through current and past hashes if key value matches
			group_current_hash.each_key{ |key|
				if (group_past_hash.key?(key) == true)
						
					group_past_hash.each_key { |i|
			 						
			 			if (key == i)
			 						
			 				arr = []
							arr.push(group_current_hash[key]) # pushing current hash to array
							arr.push(group_past_hash[i]) # pushing past hash to array
							change_maths = (((group_current_hash[key][0][:maths] - group_past_hash[key][0][:maths])*100.to_f)/group_past_hash[key][0][:maths]).round(2) # calculating change of maths
							change_physics = (((group_current_hash[key][0][:physics] - group_past_hash[key][0][:physics])*100.to_f)/group_past_hash[key][0][:physics]).round(2) # calculating change of physics
							change_chemistry = (((group_current_hash[key][0][:chemistry] - group_past_hash[key][0][:chemistry])*100.to_f)/group_past_hash[key][0][:chemistry]).round(2) # calculating change of chemistry
							change_hash = [{:change_maths => change_maths, :change_physics => change_physics, :change_chemistry => change_chemistry, :change=>"change"}]
							arr.push(change_hash) # pushing change hash to array
							final_hash[key] = arr
				
						end
					}
							
				else()

					change_maths = 100
					change_physics = 100
					change_chemistry = 100

					change_hash = [{:change_maths => change_maths, :change_physics => change_physics, :change_chemistry => change_chemistry, :change=>"change"}]
							
					arr = []
					arr.push(group_current_hash[key]) # pushing current hash to array
					arr.push([{:maths => 0, :physics => 0, :chemistry => 0, :year => get_past_year.to_i}]) # pushing past hash to array
					arr.push(change_hash) # pushing change hash to array
					final_hash[key] = arr

				end

			}

			Rails.logger.debug "#{final_hash}"
			@@final_compare_hash = final_hash
			Rails.logger.debug "final_compare_hash: "
		
		elsif
			Rails.logger.debug "Inside elsif"
			group_current_hash = current_hash.group_by {|i| i[:dept]}
			Rails.logger.debug "#{group_current_hash}"
			group_past_hash = past_hash.group_by {|j| j[:dept]}
			Rails.logger.debug "#{group_past_hash}"
			final_hash = {}
			
			group_current_hash.each_key{ |key|
				Rails.logger.debug "Inside group_current_hash"
				mathstotal = 0
				physicstotal = 0
				chemistrytotal = 0
				current_arr = []
				len = group_current_hash[key].length

				for i in 0..len-1
					mathstotal = mathstotal + group_current_hash[key][i][:maths]
					physicstotal = physicstotal + group_current_hash[key][i][:physics]
					chemistrytotal = chemistrytotal + group_current_hash[key][i][:chemistry]
				end
				current_arr.push([{:year => 2016, :mathstotal => mathstotal, :physicstotal => physicstotal, :chemistrytotal => chemistrytotal }])
				Rails.logger.debug "#{current_arr}"
				if (group_past_hash.key?(key) == true)
					group_past_hash.each_key{ |k|
						if (key == k)
							Rails.logger.debug "Inside group_past_hash"
							mathstotal = 0
							physicstotal = 0
							chemistrytotal = 0
							len = group_past_hash[k].length

							for i in 0..len-1
								mathstotal = mathstotal + group_past_hash[k][i][:maths]
								physicstotal = physicstotal + group_past_hash[k][i][:physics]
								chemistrytotal = chemistrytotal + group_past_hash[k][i][:chemistry]
							end
						end
					
					}
					current_arr.push([{:year => 2015, :mathstotal => mathstotal, :physicstotal => physicstotal, :chemistrytotal => chemistrytotal }])
					final_hash[key] = current_arr
					Rails.logger.debug "current_arr: "
					Rails.logger.debug "#{current_arr.inspect}"
					Rails.logger.debug "final_hash: "
					Rails.logger.debug "#{final_hash.inspect}"

				end
			}
			final_hash.each_key { |k|
				change_maths = (((final_hash[k][0][0][:mathstotal] - final_hash[k][1][0][:mathstotal])*100.to_f)/final_hash[k][1][0][:mathstotal]).round(2) # calculating change of maths
				change_physics = (((final_hash[k][0][0][:physicstotal] - final_hash[k][1][0][:physicstotal])*100.to_f)/final_hash[k][1][0][:physicstotal]).round(2) # calculating change of physics
				change_chemistry = (((final_hash[k][0][0][:chemistrytotal] - final_hash[k][1][0][:chemistrytotal])*100.to_f)/final_hash[k][1][0][:chemistrytotal]).round(2) # calculating change of chemistry
				change_hash = [{:change=>"change", :change_maths => change_maths, :change_physics => change_physics, :change_chemistry => change_chemistry}]
				final_hash[k].push(change_hash)
			}
			Rails.logger.debug "#{final_hash}"
			@@final_compare_hash = final_hash
			Rails.logger.debug "final_compare_hash: "
			
		end
  	end

  	def sort_by(grouped_hash)
  		Rails.logger.debug "inside Sort by"
  		Rails.logger.debug "#{params["sort"]}"
  		get_sort = params["sort"]
  		sorted_hash = grouped_hash.sort_by { |key| key[get_sort.to_sym]}
  		
  		Rails.logger.debug "sorted_has: #{sorted_hash.inspect}"
  		return sorted_hash
  	end

  	def group_by(grouped_hash)
  		Rails.logger.debug "inside group_by"
  		get_group = params["group"]	
  																		
		grouped_hash = grouped_hash.group_by { |h| h[get_group.to_sym] } # grouping student_hash by the user input
		Rails.logger.debug "grouped hash: #{grouped_hash.inspect}"
		
		arr_hash = []
		
		# running loop through grouped_hash to find the averages of maths,physics,chemistry and pushing to arr_hash	
		grouped_hash.each_key{ |k| 
		
			length = grouped_hash[k].length		
			maths_sum = 0
			physics_sum = 0
			chemistry_sum = 0
			for i in 0..length-1
		
				maths_sum = maths_sum + (grouped_hash[k][i][:maths])
				physics_sum = physics_sum + (grouped_hash[k][i][:physics])
				chemistry_sum = chemistry_sum + (grouped_hash[k][i][:chemistry])
				
			end 
		
			maths_avg = (maths_sum.to_f/length).round(2)
			physics_avg = (physics_sum.to_f/length).round(2)
			chemistry_avg = (chemistry_sum.to_f/length).round(2)
			
			arr_hash.push({:id=>k, :maths=>maths_avg, :physics=>physics_avg, :chemistry=>chemistry_avg}) # pushing the hashes to arr_hash
		
		}
		Rails.logger.debug "arr_hash #{arr_hash.inspect}"	
		return arr_hash # returing arr_hash
		
  	end

  	def results
  		Rails.logger.debug "Inside results method"
  		@finalhash = @@final_sorted_hash unless @@final_sorted_hash.nil?
  		@compare = @@get_compare
  		@total = @@get_total
  		@final_hash = @@final_compare_hash unless @@final_compare_hash.nil?
  		@totalhash = @@total_hash unless @@total_hash.nil?
  	end

end
