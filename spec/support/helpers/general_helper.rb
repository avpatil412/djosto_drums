# Please put the reusable methods required for your spec files here.
require './spec/spec_helper.rb'
#require '../../page_object/all_page_objects'

class CommonMethods

def get_current_time
   Time.now
end

def end_time(time)
  start_time = get_current_time
  puts "start_time is #{start_time}"
  new_time=time.split(".")
  mins = (new_time[0]).to_i*60
  seconds = new_time[1].to_i
  puts "end_time *******",start_time + mins + seconds
  end_time=start_time + mins + seconds
end



end
