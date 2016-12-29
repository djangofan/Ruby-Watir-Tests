require "watir"
require "rspec"
require "sauce_whisk"

RSpec.configure do | config |
  config.before(:each) do | test |
    capabilities = {
      version: ENV['version'],
      browserName: ENV['browserName'],
      platform: ENV['platform'],
      name: test.full_description,
      build: ENV['BUILD_TAG'] || "Unknown Build - #{Time.now.to_i}",
    }

    url = "https://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:443/wd/hub".strip

    @browser = Watir::Browser.new(:remote, url: url, desired_capabilities: capabilities)
  end

  config.after(:each) do | example |
    session_id = @browser.wd.session_id
    SauceWhisk::Jobs.change_status(session_id, example.exception.nil?)
  end
end
