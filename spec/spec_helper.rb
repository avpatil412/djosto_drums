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
require 'Concurrent'
require 'fileutils'

Capybara.default_driver = :selenium
APP_URL="http://drums.dojosto.com"


RSpec.configure do |config|
  config.before(:suite) do
    Capybara.default_max_wait_time = 20
    case ENV["CLIENT"]
      when nil
        client = "chrome"
      when "chrome", "firefox", "safari"
        client = ENV["CLIENT"]
      else
        client = "chrome"
    end
    case client
      when "chrome"
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, :browser => :chrome)
        end
        Capybara.javascript_driver = :chrome
      when "firefox"
        Capybara.register_driver :selenium do |app|
           Capybara::Selenium::Driver.new(app, :browser => :firefox)
        end
        Capybara.javascript_driver = :firefox
      when "safari"
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, :browser => :safari, :extensions => ["SafariDriver.safariextz"])
        end
         Capybara.javascript_driver = :safari
    end
  end

  config.before(:each) do
    visit APP_URL
  end

  config.after(:suite) do
    RSpec.world.all_examples.each do |example|
      if example.pending?
        puts "  - Pending test: #{example.location}"
      end
    end
  end

  config.after(:each) do |scenario|
    if scenario.exception
      begin
        screenshot_setup
      rescue Capybara::Selenium::Driver
        puts "Window not found! Unable to make screenshot!"
      end
    else
      begin
        screenshot_setup
      rescue Capybara::Selenium::Driver
        puts "Window not found! Unable to make screenshot!"
      end
    end
  end

  def screenshot_setup
    @dirname = FileUtils.pwd + "/temp/failures_screenshots"
    FileUtils.mkdir_p(@dirname) unless File.directory?(@dirname)
    Capybara::Screenshot.prune_strategy = { keep: 10 }
    Capybara.save_path = @dirname
    Capybara::Screenshot.autosave_on_failure = true
    Capybara::Screenshot.append_timestamp = true
    Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |scenario|
      "screenshot_#{scenario.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')}"
    end
  end
end
