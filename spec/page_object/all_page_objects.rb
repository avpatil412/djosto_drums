# file: page_objects/all_page_objects.rb
require './spec/spec_helper.rb'
require 'capybara/dsl'
include Capybara::DSL

current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path, 'drums_dojosto')

Dir.glob(File.join(current_path, '**', '*.rb')).each do |file|
  require file
end

def pattern(input,index)
  wait_until_visible(:xpath,"//ul[@id='dm-grid']/li[#{input}]/ul/li[#{index+1}]/button")
  page.find(:xpath,"//ul[@id='dm-grid']/li[#{input}]/ul/li[#{index+1}]/button" )
end

def play_track
  wait_until_visible(:id,"play")
  page.find(:id,"play")
end

def clear_track
  wait_until_visible(:id,"reset")
  page.find(:id,"reset")
end

def get_bpm_min_max
  wait_until_visible(:css, "span[id='tempo'] input")
  page.find(:css, "span[id='tempo'] input")
end

def set_bpm_css
  "#tempo input[class='ng-pristine ng-valid']"
end

def confirm_beat_css
 "div.ng-binding.current-beat"
end

