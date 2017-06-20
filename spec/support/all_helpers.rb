# file: support/all_helpers.rb
#
current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path, 'helpers')

Dir.glob(File.join(current_path, '**', '*.rb')).each do |file|
  require file
end

