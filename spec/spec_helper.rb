require 'capybara/rspec'
require 'capybara'
require_relative 'page_object/all_page_objects'
require_relative 'support/all_helpers'
require 'selenium-webdriver'
require 'pry'
require 'site_prism'
require 'yaml'
require 'capybara-screenshot/rspec'
require 'active_support/all'
require 'yaml'
require 'time'

Capybara.default_driver = :chrome
Capybara.register_driver :chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => [ "--start-maximized" ]})
  $driver = Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
end
Capybara.javascript_driver = :chrome
APP_URL="http://drums.dojosto.com"

RSpec.configure do |config|
  config.before(:suite) do
    Capybara.default_max_wait_time = 10
  end

  config.before(:each) do
    visit APP_URL
  end

  config.after(:suite) do
  end
end
