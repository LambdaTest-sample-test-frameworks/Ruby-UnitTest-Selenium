require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require_relative  "readConf"

class UnitTestLTSample < Test::Unit::TestCase

    def setup
		config = ReadConfig.new()	
		lt_user = ENV['LT_USERNAME']
		lt_key = ENV['LT_ACCESS_KEY']
		lt_os = ENV['LT_OPERATING_SYSTEM']
		lt_browser = ENV['LT_BROWSER']
		lt_browser_version = ENV['LT_BROWSER_VERSION']
		if(lt_user == "" || lt_user == nil)
			lt_user = config.getDetails('LT_USERNAME')
		end
		if(lt_key == "" || lt_key == nil)
			lt_key = config.getDetails('LT_ACCESS_KEY')
		end
		if(lt_browser == "" || lt_browser == nil)
			lt_browser = config.getDetails('LT_BROWSER')
		end
		if(lt_os == "" || lt_os ==nil)
			lt_os = config.getDetails('LT_OPERATING_SYSTEM')
		end
		if(lt_browser_version == "" || lt_browser_version == nil)
			lt_browser_version = config.getDetails('LT_BROWSER_VERSION')
		end	
		caps = {						
			:browserName => lt_browser,			
			:version => lt_browser_version,			
			:platform =>  lt_os,
			:name =>  "UnitTest Sample Test",
			:build =>  "UnitTest Selenium Build"
		} 	
		puts (caps)
		@driver = Selenium::WebDriver.for(:remote,
			:url => "http://"+lt_user+":"+lt_key+"@hub.lambdatest.com/wd/hub",
			:desired_capabilities => caps)
		
		@driver.manage.window.maximize
		
        @driver.get("https://lambdatest.github.io/sample-todo-app/" )
        sleep(10)
	end

    def test_Login
        item_name = "Yey, Lets add it to list"

        #Click on First Checkbox
        fCheckbox = @driver.find_element(:name, 'li1')
        fCheckbox.click

        #Click on Second Checkbox
        sCheckbox = @driver.find_element(:name, 'li2')
        sCheckbox.click
    
        #Enter Item Name 
        itemNameInput = @driver.find_element(:id, 'sampletodotext')
        itemNameInput.send_keys item_name
        
        #Click on Add Button
        addButton = @driver.find_element(:id, 'addbutton')
        addButton.submit

        # Verify Added Item
        getItemName = @driver.find_element(:xpath, '/html/body/div/div/div/ul/li[6]/span').text
		assert_equal(getItemName, item_name )
    end
    
    def teardown
		@driver.quit
	end
	
end
