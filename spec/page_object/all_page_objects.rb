# file: page_objects/all_page_objects.rb
require './spec/spec_helper.rb'

current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path, 'drums_dojosto')

Dir.glob(File.join(current_path, '**', '*.rb')).each do |file|
  require file
end

def set_pattern(type,key)
  input =case type
           when "kick" then "2"
           when "snare" then "3"
           when "hc" then "4"
           when "ho" then "5"
         end
  find(:xpath,"//ul[@id='dm-grid']/li[#{input}]/ul/li[#{key+1}]/button" ).click
end

def click_play
  find(:id,"play").click
end

def click_clear
  find(:id,"reset").click
end

def set_bpm(value)
  #execute_script($("#tempo input[class='ng-pristine ng-valid']")).slider('values',0,90)
  cal = find(:css, "#tempo input[class='ng-pristine ng-valid']")
  attri = find(:css, "#tempo input[class='ng-pristine ng-valid']").value
  puts "** attribute 1 is #{attri}"
  page.driver.browser.action.move_to(cal.native).click_and_hold.move_to(cal.native,0,0).move_to(cal.native,value,0).release.perform
  attri2 = find(:css, "input.ng-valid.ng-dirty").value
  puts "** attribute 2 is #{attri2}"
end

def last_beat
  find('div.ng-binding.current-beat').value
end

def confirm_last_beat
  expect(page).to have_css('div.ng-binding.current-beat', text: "16")
end
