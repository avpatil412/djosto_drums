# Please write the test cases in files over here.
require './spec/spec_helper.rb'
require './spec/support/helpers/general_helper.rb'

RSpec.describe "test", :type => :feature do
tests_cases.each do |tests|
  it "Play the drum for #{tests["test_case"]}"  do
    click_clear

    tests["kick"].each do |x|
      set_pattern("kick",x)
    end
    tests["snare"].each do |x|
      set_pattern("snare",x)
    end
    tests["hc"].each do |x|
      set_pattern("hc",x)
    end
    tests["ho"].each do |x|
      set_pattern("ho",x)
    end
    set_bpm(tests["bpm"])
    end_time = @helper.end_time(tests["time"])
    count = tests["play"]
    (1..count).each do |i|
      click_play
      puts "play #{i}"
      confirm_last_beat
      puts "found 16 for play #{i}"
    end
    while Time.now < end_time do
      puts "I am playing my final beat"
      confirm_last_beat
      puts "Done playing after 16"
    end #puts "hey sexy baby"
    end
end

  before(:all) do
    @helper = CommonMethods.new
  end
end


