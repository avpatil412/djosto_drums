# Please put the reusable methods required for your spec files here.
require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'capybara/dsl'
require 'capybara/rspec/matchers'
include RSpec::Matchers

module CommonMethods

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
  start_time + mins + seconds
end

def wait_until_visible(type, selector,time=5)
  t ||= 0
  begin
    element = page.find(type, selector)
  rescue => e
    puts "Polling for the locator"
    while (t<time) and element == 0
      element = page.find(selector)
      sleep 0.5
      t+=0.5
    end
    puts e.message
  end
end


def set_pattern(type,keys)
  input =case type
           when "kick" then "2"
           when "snare" then "3"
           when "hc" then "4"
           when "ho" then "5"
         end
  keys.each do |x|
    pattern(input,x).click
  end
end

def click_play
  play_track.click
end

def click_clear
  clear_track.click
end

def change_bpm(bpm)
  bpm_min = get_bpm_min_max[:min]
  bpm_max = get_bpm_min_max[:max]
  css = set_bpm_css
    if bpm.to_f <= bpm_max.to_f && bpm.to_f >= bpm_min.to_f
      puts "\nBPM value set to #{bpm.to_f}"
      page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
    elsif bpm.to_f < bpm_min.to_f
      puts "\nInput BPM value <  min value of BPM(#{bpm_min}) toggle. Overriding min value for testing only"
      page.execute_script("document.querySelector(\"#{css}\").setAttribute('min','#{bpm.to_s}');")
      page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
      puts "BPM Value overridden and set to #{bpm.to_s} bpm"
     else
      puts "\nInput bpm value > max value of BPM(#{bpm_max}) toggle. Overriding max value for testing only"
      page.execute_script("document.querySelector(\"#{css}\").setAttribute('max','#{bpm.to_s}');")
      page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
      puts "BPM overridden and set to #{bpm.to_s} bpm"
    end
end

def confirm_beat(beat_number)
  wait_until_visible(:css, confirm_beat_css)
  expect(page).to have_css(confirm_beat_css, text: "#{beat_number}")
end

end

