# Please put the reusable methods required for your spec files here.
require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'capybara/dsl'
require 'capybara/rspec/matchers'

module CommonMethods

  include RSpec
  include Capybara
 # @wait = Capybara::Queries::BaseQuery.new(wait)

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

def wait_until_visible(params)
  t ||= 0
  begin
    Capybara.default_max_wait_time
      puts "hurray! I found my locator #{params}"
    #expect(params).to be_visible
  rescue => e
    puts "waiting for element to load ...."
    time=Capybara.default_max_wait_time
    active = expect(params).to be_visible
    puts "Retrying #{t}..."
    while t<time and ! active
      t +=0.5
      active = expect(params).to be_visible
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
    wait_until_visible(pattern(input,x))
    pattern(input,x).click
  end
end

def click_play
  wait_until_visible(play)
  play.click
end

def click_clear
  wait_until_visible(clear)
  clear.click
end

def change_bpm(bpm)
  wait_until_visible(get_bpm_min_max)
  bpm_min = get_bpm_min_max[:min]
  bpm_max = get_bpm_min_max[:max]
  wait_until_visible(set_bpm_css)
  css = set_bpm_css
  case bpm.to_f
    when bpm_min.to_f..bpm_max.to_f
      page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
    else
      if bpm.to_f < bpm_min.to_f
        puts "\nInput BPM value is less than min value of BPM(#{bpm_min}) toggle. Overriding min value for testing purposes"
        page.execute_script("document.querySelector(\"#{css}\").setAttribute('min','#{bpm.to_s}');")
        page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
        puts "BPM Value overridden and set to #{bpm.to_s} bpm"
      else
        puts "\nInput BPM value is greater than max value of BPM(#{bpm_max}) toggle. Overriding max value for testing purposes"
        page.execute_script("document.querySelector(\"#{css}\").setAttribute('max','#{bpm.to_s}');")
        page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
        puts "BPM overridden and set to #{bpm.to_s} bpm"
      end
  end
end

def confirm_beat(beat_number)
  wait_until_visible(confirm_beat_css)
  expect(page).to have_css(confirm_beat_css, text: "#{beat_number}")
end

end

