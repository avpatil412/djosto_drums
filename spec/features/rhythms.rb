# Please write the test cases in files over here.
require './spec/spec_helper.rb'
require './spec/support/helpers/general_helper.rb'
include CommonMethods

def tests_cases
  [
  {
      "test_case" => "Rhythm01",
      "bpm"=>60,
      "time"=>"1.59",
      "play" => 3,
      "pattern"=>{
        "kick"=>[2,4,6,10,12,16],
        "snare"=>[3,6,8,14,],
        "hc" => [2,4,5,12,16],
        "ho"=>[4,7,10,15]
      }
  },
  {
      "test_case" => "Rhythm02",
      "bpm"=>110,
      "time"=>"1.40",
      "play" => 2,
      "pattern"=>{
          "kick"=>[3,7,8,10,12,15,16],
          "snare"=>[6,9,11,12,14],
          "hc"=>[2,4,7,9,10,16],
          "ho"=>[3,5,8,11,13,14],
      }
  },
  {
      "test_case" => "Rhythm03",
      "bpm"=>50,
      "time"=>"0.30",
      "play" => 1,
      "pattern"=>{
          "kick"=>[5,6,9,10,13,16],
          "snare"=>[3,7,8,9,11,12,15],
          "hc"=>[4,6,10,13],
          "ho"=>[2,4,8,10,14,16],
      }
  },
  {
      "test_case" => "Rhythm04",
      "bpm"=>90,
      "time"=>"1.9",
      "play" => 2,
      "pattern"=>{
          "kick"=>[4,6,12,14,16],
          "snare"=>[2,7,9,10,13,15],
          "hc"=>[2,4,5,11,13,15],
          "ho"=>[3,7,9,11,14,16],
      }
  }
  ]
end

RSpec.describe "test scenarios", :type => :feature do
tests_cases.each do |tests|
  it "Play the drum for #{tests["test_case"]}"  do
    @helper.click_clear
    tests["pattern"].each do |p|
      @helper.set_pattern(p[0],p[1])
     end
    @helper.change_bpm(tests["bpm"])
    end_time = @helper.end_time(tests["time"])
    (0..tests["play"]).each do |i|
      @helper.click_play
      puts "play clicked #{i}th time"
      #commenting this as there is no requirement to validate 1 complete beat of rhythm is played before playing next beat.
      #puts "play #{i}"
      #confirm_beat(16)
      #puts "found 16 for play #{i}"
    end
    while @helper.get_current_time < end_time do
      puts "I am playing my final beat"
      get_beat_number
      @helper.assert_beat_play(get_beat_number)
      puts "Done playing after 16"
    end
  end
end

  before(:all) do
    @helper = CommonMethods
  end
end



