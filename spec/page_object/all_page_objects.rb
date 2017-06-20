# file: page_objects/all_page_objects.rb
require './spec/spec_helper.rb'

current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path, 'drums_dojosto')

Dir.glob(File.join(current_path, '**', '*.rb')).each do |file|
  require file
end

def set_pattern(type,keys)

  input =case type
           when "kick" then "2"
           when "snare" then "3"
           when "hc" then "4"
           when "ho" then "5"
         end
  keys.each do |x|
    find(:xpath,"//ul[@id='dm-grid']/li[#{input}]/ul/li[#{x+1}]/button" ).click
  end

end

def click_play
  find(:id,"play").click
end

def click_clear
  find(:id,"reset").click
end


def change_bpm(bpm)
  bpm_min_val = find(:css, "span[id='tempo'] input")[:min]
  bpm_max_val = find(:css, "span[id='tempo'] input")[:max]
  css = "#tempo input[class='ng-pristine ng-valid']"
  case bpm.to_f
    when bpm_min_val.to_f..bpm_max_val.to_f
      page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
    else
      if bpm.to_f < bpm_min_val.to_f
        puts "\nGiven BPM value is less than min value of BPM(#{bpm_min_val}) toggle. Overriding min value for testing purposes"
        page.execute_script("document.querySelector(\"#{css}\").setAttribute('min','#{bpm.to_s}');")
        page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
        print "BPM Value has been overridden and set to #{bpm.to_s} bpm"
      else
        puts "\nGiven BPM value is greater than max value of BPM(#{bpm_max_val}) toggle. Overriding max value for testing purposes"
        page.execute_script("document.querySelector(\"#{css}\").setAttribute('max','#{bpm.to_s}');")
        page.execute_script("document.querySelector(\"#{css}\").value='#{bpm.to_s}';")
        print "BPM Value has been overridden and set to #{bpm.to_s} bpm"
      end
  end
end


def last_beat
  find('div.ng-binding.current-beat').value
end

def confirm_last_beat
  expect(page).to have_css('div.ng-binding.current-beat', text: "16")
end

def confirm_beat(beat_number)
  expect(page).to have_css('div.ng-binding.current-beat', text: "#{beat_number}")
end
