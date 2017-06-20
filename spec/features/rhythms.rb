# Please write the test cases in files over here.
require './spec/spec_helper.rb'
require './spec/support/helpers/general_helper.rb'

def tests_cases
  [
=begin
  {
      "test_case" => "rhythm01",
      "bpm"=>60,
      "time"=>"1.59",
      "kick"=>[2,4,6,10,12,16],
      "snare"=>[3,6,8,14,],
      "hc" => [2,4,5,12,16],
      "ho"=>[4,7,10,15],
      "play" => 3
  },
=end
  {
      "test_case" => "rhythm02",
      "bpm"=>110,
      "time"=>"1.40",
      "play" => 2,
      "pattern"=>{
          "kick"=>[3,7,8,10,12,15,16],
          "snare"=>[6,9,11,12,14],
          "hc"=>[2,4,7,9,10,16],
          "ho"=>[3,5,8,11,13,14],
      }
  }
  ]
end

RSpec.describe "test scenarios", :type => :feature do
tests_cases.each do |tests|
  it "Play the drum for #{tests["test_case"]}"  do
    click_clear
    tests["pattern"].each do |p|
      set_pattern(p[0],p[1])
     end
    change_bpm(tests["bpm"])
    end_time = @helper.end_time(tests["time"])
    count = tests["play"]
    (1..count).each do |i|
      click_play
      #puts "play #{i}"
      #confirm_last_beat
      #puts "found 16 for play #{i}"
    end
    while @helper.get_current_time < end_time do
      log.info "I am playing my final beat"
      (1..16).each do |beat_number|
        confirm_beat(beat_number)
      end
      log.info "Done playing after 16"
    end
  end
end

  before(:all) do
    @helper = CommonMethods.new
  end
end


