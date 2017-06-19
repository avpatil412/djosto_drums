# file: support/all_helpers.rb
#
current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path, 'helpers')

Dir.glob(File.join(current_path, '**', '*.rb')).each do |file|
  require file
end

def tests_cases
 [
   "test_case" => "rhythm01",
   "bpm"=>0,
   "time"=>"1.59",
   "kick"=>[2,4,6,10,12,16],
   "snare"=>[3,6,8,14,],
   "hc" => [2,4,5,12,16],
   "ho"=>[4,7,10,15],
   "play" => 3
  ]

end
