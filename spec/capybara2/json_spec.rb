require 'spec_helper'

[ :rack_test_json, :httpclient_json ].each do |driver|
  describe "to require 'capybara/json'" do
    it "should register driver #{driver}" do
      Capybara.drivers.should have_key(driver)
    end
  end

  describe Capybara::Json do
    include described_class

    before(:all) do
      Capybara.app = JsonTestApp
      Capybara.current_driver = driver
    end

    after(:all) do
      Capybara.app = nil
      Capybara.current_driver = Capybara.default_driver
    end

    %w[ get get! delete delete! ].each do |method|
      it "register #{method}" do
        __send__(method, '/')
        json.should == { 'Hello world!' => 'Hello world!' }
      end
    end

    %w[ post post! put put! ].each do |method|
      it "register #{method}" do
        __send__(method, '/', {})
        json.should == { 'Hello world!' => 'Hello world!' }
      end

      it "#{method} send json" do
        post_body = { "some" => "args" }
        __send__(method, '/env', post_body)

        json['content_type'].should =~ %r"application/json"
        json['rack.input'].should == MultiJson.dump(post_body)
      end
    end
  end
end
