module BasePage


  def save_screenshot_to(folder,file_name=nil)
    dirname = Dir.pwd + "/temp/#{folder}"
    Dir.mkdir(dirname) unless File.directory?(dirname)
    name = file_name ? file_name : Time.now.strftime('%Y%m%d%H%M%S%L') + ".png"
    @driver.save_screenshot(Dir.pwd + "/temp/#{folder}/#{name}")
    Dir.pwd + "/temp/#{folder}/#{name}"
  end

  def click_element(selector,t=5)
    wait_for_element(selector,t)
    wait_for_element_to_be_visible(selector,t)
    wait_for_element_to_be_active(selector,t)

    if is_element_active(selector)
      if ENV['BROWSER'] == 'chrome'
        element_to_click = selector ? @driver.find_element(selector) : @driver.find_element(selector)
        @driver.action.click(element_to_click).perform
        # @driver.execute_script("arguments[0].scrollIntoView()" , @driver.find_element(selector))
        # @driver.find_element(selector).click
      else
        scroll_to_element_js(selector)
        @driver.find_element(selector).click
      end
    else
      log "Button is inactive!"
      fail
    end
  rescue Selenium::WebDriver::Error::ElementNotVisibleError => e
    log "Cannot click element with selector #{selector}"
    save_screenshot_to("create_label","click_button#{Time.now.strftime('%Y%m%d%H%M%S%L') + ".png"}")
    raise e
  end

  def click_element_without_scroll_js(selector,t=5)
    wait_for_element(selector,t)
    wait_for_element_to_be_visible(selector,t)
    wait_for_element_to_be_active(selector,t)

    if is_element_active(selector)
      if ENV['BROWSER'] == 'chrome'
        element_to_click = selector ? @driver.find_element(selector) : @driver.find_element(selector)
        @driver.action.click(element_to_click).perform
        # @driver.execute_script("arguments[0].scrollIntoView()" , @driver.find_element(selector))
        # @driver.find_element(selector).click
      else
        #scroll_to_element_js(selector)
        @driver.find_element(selector).click
      end
    else
      log "Button is inactive!"
      fail
    end
  rescue Selenium::WebDriver::Error::ElementNotVisibleError => e
    log "Cannot click element with selector #{selector}"
    save_screenshot_to("create_label","click_button#{Time.now.strftime('%Y%m%d%H%M%S%L') + ".png"}")
    raise e
  end

  def custom_click(area,selector,num)
    area ? area.find_elements(selector)[num].click : @driver.find_elements(selector)[num].click
  end

  def clear(selector)
    input = @driver.find_element(selector)
    input.clear
  end

  def fill_with(selector, text,area=nil,time_to_wait=5)
    area ? wait_for_element(selector,time_to_wait,area) : wait_for_element(selector,time_to_wait)
    area ? wait_for_element_to_be_visible(selector,time_to_wait,area) : wait_for_element_to_be_visible(selector,time_to_wait)
    area ? wait_for_element_to_be_active(selector,time_to_wait,area) : wait_for_element_to_be_active(selector,time_to_wait)
    input = area ? @driver.find_element(area).find_element(selector) : @driver.find_element(selector)
    input.clear
    input.send_keys(text)
  end

  def get_textbox_value(textbox_selector)
    textbox_value = @driver.find_element(textbox_selector).attribute('value')
    $log.info "Text Box value - #{textbox_value}"
    return textbox_value
  end

  def get_element_text(selector)
    @driver.find_element(selector).text
  end

  def select_from_dropdown(dropdown_selector, option_value,area=nil,attr="value")
    select_element = @driver.find_element(dropdown_selector)
    select_element.click
    option_element = select_element.find_elements(:tag_name => "option").find do |option|
      option.attribute("value") == option_value
    end
    option_element.click
    option_element.send_keys(:return)
  end

  def get_selected_element(dropdown_selector)
    wait_for_element(dropdown_selector)
    dropdown = @driver.find_element(dropdown_selector)
    select_list = Selenium::WebDriver::Support::Select.new(dropdown)
    select_list.first_selected_option.text
  end

  def select_from_dropdown_by_text(dropdown_selector, select_text,area=nil)
    wait_for_element(dropdown_selector)
    wait_for_element_to_be_visible(dropdown_selector,1)
    wait_for_element_to_be_active(dropdown_selector,1)
    dropdown = area ? @driver.find_element(area).find_element(dropdown_selector) : @driver.find_element(dropdown_selector)
      Selenium::WebDriver::Support::Select.new(dropdown).select_by(:text, select_text)
  end

  def select_from_dropdown_by_value(dropdown_selector, select_text,area=nil)
    wait_for_element(dropdown_selector)
    wait_for_element_to_be_visible(dropdown_selector,1)
    wait_for_element_to_be_active(dropdown_selector,1)
    dropdown = area ? @driver.find_element(area).find_element(dropdown_selector) : @driver.find_element(dropdown_selector)
    Selenium::WebDriver::Support::Select.new(dropdown).select_by(:value, select_text)
  end

  def get_dropdown_value(dropdown_selector)
    selected_value = @driver.find_element(dropdown_selector).attribute('value')
    $log.info "Drop Down selected value - #{selected_value}"
    return selected_value
  end

  def select_from_dropdown_by_option(dropdown_selector, option_selector, option_value)
    select_element = @driver.find_element(dropdown_selector)
    sleep 1
    select_element.click
    wait_for_element_to_be_visible(option_selector, 20)
    select_element = @driver.find_element(option_selector)
    option_element = select_element.find_elements({css: ".option"}).find do |option|
      option.text == option_value
    end
    option_element.click
    #option_element.send_keys(:return)
  end

  def element(selector,time=5)
    wait_for_element(selector,time)
    @driver.find_element(selector)
  end

  def elements(selector,time=5)
    wait_for_element(selector,time)
    @driver.find_elements(selector)
  end

  def is_element_active(selector,area=nil)
    area ? element(area).find_element(selector).attribute("disabled").nil? : element(selector).attribute("disabled").nil?
  end

  def get_element_state(selector)
    element(selector).selected?.to_s
  end

  # selector - element selector (e.g. {css: ".class"})
  # to_select - boolean, true if you want element to be active
  def set_element_selected(label_selector, checkbox_selector, to_select)
    element_to_select = element(label_selector)
    element_to_check = element(checkbox_selector)
    element_to_select.click if (element_to_check.selected?.to_s != to_select)
    sleep 0.5
  end

  def set_date(date_selector,date_value)
    date_element =  @driver.find_element(date_selector)
    if date_value != nil && date_value != ''
      date_year = date_value.split('/')[2]
      date_day = date_value.split('/')[1]
      date_month = date_value.split('/')[0]
    end
  end

  def am_i_logged_in?
    elements({id: "header-user"},1).size>0
  end

  def am_i_signed_in_app
    @user_header = {id: "header-user"}
    @sign_in_form = {id: "login_Form"}
    header = is_element_present(@user_header)
    sign_in = is_element_present(@sign_in_form)
    i = 0
    while i < 10 || header || sign_in
      if header || sign_in
        return header
      else
        sleep 0.5
        i += 1
        header = is_element_present(@user_header)
        sign_in = is_element_present(@sign_in_form)
      end
    end

  end

  def am_i_signed_in?
    begin
      #wait_for_one_of_the_elements({id: "header-user"},{id: "login_Form"},5)
      return true if is_element_present({id: "header-user"})
      #return false if is_element_present({id: "login_Form"})
      false
    rescue Net::ReadTimeout,Errno::ECONNREFUSED => e
      log "Error in sign-in page Re-instantiating WebDriver...\nError: #{e.message}"
      @driver = DriverFactory.create_new_web_driver
      instantiate_pages
      shipping_services_page.switch_to_horizon_tab
      @driver.get($domain + "/home")
      wait_for_one_of_the_elements({id: "header-user"},{id: "login_Form"},5)
      return true if is_element_present({id: "header-user"})
      return false if is_element_present({id: "login_Form"})
      false
    end
  end

  def am_i_signed_in_spp?
    begin
      #wait_for_one_of_the_elements({id: "header-user"},{id: "login_Form"},5)
      return true if is_element_present({id: "header-user"})
      #return false if is_element_present({id: "login_Form"})
      false
    rescue Net::ReadTimeout,Errno::ECONNREFUSED => e
      log "Error in sign-in page Re-instantiating WebDriver...\nError: #{e.message}"
      @driver = DriverFactory.create_new_web_driver
      instantiate_pages
      shipping_services_page.switch_to_horizon_tab
      @driver.get($sppdomain + "/home")
      wait_for_one_of_the_elements({id: "header-user"},{id: "login_Form"},5)
      return true if is_element_present({id: "header-user"})
      return false if is_element_present({id: "login_Form"})
      false
    end
  end

  def am_i_logged_in_as_user(user_name)
    @driver.get($domain + "/userProfileEdit")
    wait_for_spinner_to_disappear
    begin
      display_name = element({id:"profile-email"}).text
      log "display name: #{display_name}"
      return display_name.downcase == user_name.downcase
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return false
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      return false
    end
  end

  def am_i_logged_in_as_sppuser(user_name)
    log $sppdomain + "/userProfileEdit"
    @driver.get($sppdomain + "/userProfileEdit")
    wait_for_spinner_to_disappear
    begin
      display_name = element({id:"profile-email"}).text
      log "display name: #{display_name}"
      return display_name.downcase == user_name.downcase
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return false
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      return false
    end
  end

  def am_i_in_signIn_page
    element_selector = {css: "input[alt='Sign In']"}
    begin
      wait_for_element_to_be_active(element_selector)
      @driver.find_element(element_selector)
      return true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return false
    end
  end

  def drop_down_search_and_select(selector, search_key)
    begin
      wait_for_element_to_be_visible({css:".selectize-input"}, 10, selector)
      chrome_scrollintoview(element(selector).find_element({css:".selectize-input"}))
      element(selector).find_element({css:".selectize-input"}).click

      element(selector).find_element({css:"input[type=search]"}).clear
      element(selector).find_element({css:"input[type=search]"}).send_keys(search_key.to_s)
      element(selector).find_element({css:"div.option.ui-select-choices-row-inner > div"}).click
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      chrome_scrollintoview(element(selector).find_element({css:".selectize-input"}))
      element(selector).find_element({css:".selectize-input"}).click

      element(selector).find_element({css:"input[type=search]"}).clear
      element(selector).find_element({css:"input[type=search]"}).send_keys(search_key.to_s)
      element(selector).find_element({css:"div.option.ui-select-choices-row-inner > div"}).click
    rescue Selenium::WebDriver::Error::InvalidElementStateError
      chrome_scrollintoview(element(selector).find_element({css:".selectize-input"}))
      element(selector).find_element({css:".selectize-input"}).click

      element(selector).find_element({css:"input[type=search]"}).clear
      element(selector).find_element({css:"input[type=search]"}).send_keys(search_key.to_s)
      element(selector).find_element({css:"div.option.ui-select-choices-row-inner > div"}).click
    end
  end

  def is_element_present(selector, selector_area=nil)
    selector_area ? selector_area.find_elements(selector).size != 0 : @driver.find_elements(selector).size != 0
  end

  def is_element_displayed(selector,selector_area=nil)
    selector_area ? selector_area.find_element(selector).displayed? : @driver.find_element(selector).displayed?
  end

  def is_element_clickable?(selector,area=nil)
    is_element_present(selector,area) && is_element_displayed(selector,area) && is_element_active(selector,area)
  end

  def reload_page
    @driver.navigate.refresh
  end

  def wait_for_element(selector,time=5,area=nil)
    t = 0
    number_of_elements = area ? @driver.find_element(area).find_elements(selector).size : @driver.find_elements(selector).size
    while (t<time) and number_of_elements == 0
      number_of_elements = area ? @driver.find_element(area).find_elements(selector).size : @driver.find_elements(selector).size
      sleep 0.5
      t+=0.5
    end
  end

  def wait_for_one_of_the_elements(selector1, selector2, time=5, area1=nil, area2=nil)
    t = 0
    number_of_elements1 = area1 ? @driver.find_element(area1).find_elements(selector1).size : @driver.find_elements(selector1).size
    number_of_elements2 = area2 ? @driver.find_element(area2).find_elements(selector2).size : @driver.find_elements(selector2).size
    while (t<time) and number_of_elements1 == 0 and number_of_elements2 == 0
      number_of_elements1 = area1 ? @driver.find_element(area1).find_elements(selector1).size : @driver.find_elements(selector1).size
      number_of_elements2 = area2 ? @driver.find_element(area2).find_elements(selector2).size : @driver.find_elements(selector2).size
      sleep 0.5
      t+=0.5
    end
  end

  def wait_for_element_to_be_visible(selector,time=5,area=nil)
    if ENV['BROWSER'].to_s.downcase == 'chrome'
      t = 0
      begin
        displayed = area ? element(area).find_element(selector).displayed? : element(selector).displayed?
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        sleep 1
        wait_for_element_to_be_visible(selector,time-1,area)
      end
      while (t<time) and displayed == false
        sleep 0.5
        t+=0.5
        begin
          displayed = area ? element(area).find_element(selector).displayed? : element(selector).displayed?
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          wait_for_element_to_be_visible(selector,time-t,area)
        end
      end
    else
      t = 0
      displayed = area ? element(area).find_element(selector).displayed? : element(selector).displayed?
      while (t<time) and displayed == false
        sleep 0.5
        t+=0.5
        displayed = area ? element(area).find_element(selector).displayed? : element(selector).displayed?
      end
    end
  end

  def wait_for_element_to_be_disappeared(selector,time=5)
    begin
      t = 0
      displayed = element(selector).displayed?
      while (t<time) and displayed == true
        sleep 0.5
        t+=0.5
        displayed = element(selector).displayed?
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError

    end
  end


  def wait_for_element_to_be_not_present(selector,time=5)
    begin
      t = 0
      displayed = is_element_present(selector)
      while (t<time) and displayed == true
        sleep 0.5
        t+=0.5
        displayed = is_element_present(selector)
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError

    end
  end


  def wait_for_alert(time=5)
    t=0
    while t<time
      begin
        @driver.switch_to.alert
        break
      rescue Selenium::WebDriver::Error::NoAlertOpenError, Net::ReadTimeout
        sleep 0.5
        t+=0.5
      end
    end
  end

  def wait_for_element_to_be_active(selector,time=5,area=nil)
    t = 0
    active = area ? is_element_active(selector,area): is_element_active(selector)
    while t<time and ! active
      sleep 0.5
      t +=0.5
      active = area ? is_element_active(selector,area): is_element_active(selector)
    end
  end

  def poll_for_element_display_and_click(selector, poll_interval=3, poll_attempt=5)
    t = 0
    displayed = element(selector).displayed?
    while (t<poll_attempt) and displayed == false
      sleep poll_interval
      t+=1
      displayed = element(selector).displayed?
      reload_page
    end
    click_element(selector)
  end

  def poll_for_element_display_and_click_without_scroll_js(selector, poll_interval=3, poll_attempt=5)
    t = 0
    displayed = element(selector).displayed?
    while (t<poll_attempt) and displayed == false
      sleep poll_interval
      t+=1
      displayed = element(selector).displayed?
      reload_page
    end
    click_element_without_scroll_js(selector)
  end

  def wait_when_loading(time = 100)
    t = 0
    if is_element_present({id: "loading-bar-spinner"})
      while t<time and @driver.find_elements({id: "loading-bar-spinner"}).size > 0
        t+=0.1
        sleep 0.1
      end
    end
  end

  #get value of element
  def get_element_value(selector)
    @driver.find_element(selector).attribute("value")
  end

  #Action builders
  def move_to_element(selector,right_by = nil, down_by = nil)
    element_to_move = selector ? @driver.find_element(selector) : @driver.find_element(selector)
    @driver.action.move_to(element_to_move).perform
  end

  def click_and_hold(selector)
     element_to_clickhold = selector ? @driver.find_element(selector) : @driver.find_element(selector)
     @driver.action.click_and_hold(element_to_clickhold).perform
  end

  def release_element(selector)
      element_to_release = selector ? @driver.find_element(selector) : @driver.find_element(selector)
      @driver.action.release(element_to_release).perform
  end

  def drag_drop(source,target)
     element_to_drag_drop_from = @driver.find_element(source)
     element_to_drag_drop_to = @driver.find_element(target)
     @driver.action.drag_and_drop(element_to_drag_drop_from,element_to_drag_drop_to).perform
  end

  #scroll
  def scroll_to_element_js(selector)
    find_element = @driver.find_element(selector)
    @driver.execute_script("arguments[0].scrollIntoView();",find_element)
  end

  def scroll_to_locator_js(element)
    @driver.execute_script("arguments[0].scrollIntoView();",element)
  end

  def chrome_scrollintoview(element)
    if ENV['BROWSER'] == 'chrome'
      scroll_to_locator_js(element)
    end
  end

  def send_key_enter
    @driver.action.send_keys(:enter).perform
    @driver.action.send_keys(:return).perform
  end

  def wait_for_spinner_to_disappear(time = 15)
    t=0
    while is_element_present({id: "loading-bar-spinner"}) and t<time
      sleep 0.5
      t+=0.5
    end
  end

  def navigate_to_last_window
    windows = @driver.window_handles
    @driver.switch_to.window(windows.last)
  end

  def navigate_to_first_window
    windows = @driver.window_handles
    @driver.switch_to.window(windows.first)
  end

  def quit_current_window
    windows = @driver.window_handles
    @driver.close() if windows.last != windows.first
  end

  def quit_last_window
    windows = @driver.window_handles
    @driver.switch_to.window(windows.last)
    @driver.close() if windows.last != windows.first
  end

  def wait_for_alert_and_accept(time=5)
    status=true
    t = 0
    while (status && t<time)
      alert = driver.switch_to.alert rescue "exception happened"
      if (alert == "exception happened")
        status = true
        alert = "nothing happened"
        t += 0.5
      else
        status = false
      end
      sleep 0.5
    end
    @driver.switch_to.alert.accept rescue $log.info "No Alert present"
  end

  def is_selected(selector,selector_area=nil)
    selector_area ? selector_area.find_element(selector).selected? : @driver.find_element(selector).selected?
  end

  def wait_for_ajax(time=10)
    wait = Selenium::WebDriver::Wait.new(:timeout => time)
    wait.until {
      running = @driver.execute_script('return (window.jQuery != undefined && jQuery.active == 0) || document.readyState == "complete" ')
    }
  end

  def click_element_if_appears(selector, time=1)
    begin
      wait_for_element(@use_entered_number_btn, time)
      click_element(selector,0) if is_element_present(selector)
    rescue
      puts "element not appeared after wait..continuing"
    end
  end

  def wait_for_text_present(selector,time=5)
    wait = Selenium::WebDriver::Wait.new(:timeout => time)
    wait.until {
      present = @driver.find_element(selector).text.length != 0 || @driver.find_element(selector).attribute("value").length !=0
    }
  end
  
end

