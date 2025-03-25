require 'appium_lib'
require 'cucumber'

def appium_caps
  platform = ENV['PLATFORM'] || 'android'

  if platform.downcase == 'ios'
    {
      caps: {
        platformName: 'iOS',
        platformVersion: '18.2', # Cambia según tu simulador
        deviceName: 'iPhone 16 Pro Max', # Cambia según el dispositivo
        app: File.join(Dir.pwd, 'features', 'app', 'iOS.Simulator.SauceLabs.Mobile.Sample.app.2.7.1.app'),
        automationName: 'XCUITest',
        noReset: false
      },
      appium_lib: {
        server_url: 'http://localhost:4723'
      }
    }
  else
    {
      caps: {
        platformName: 'Android',
        deviceName: 'emulator-5554',
        app: File.join(Dir.pwd, 'features', 'app', 'Android.SauceLabs.Mobile.Sample.app.2.7.1.apk'),
        automationName: 'UiAutomator2',
        appPackage: 'com.swaglabsmobileapp',
        appActivity: 'com.swaglabsmobileapp.SplashActivity'
      },
      appium_lib: {
        server_url: 'http://localhost:4723'
      }
    }
  end
end

Before do
  @driver = Appium::Driver.new(appium_caps, true)
  @driver.start_driver
  Appium.promote_appium_methods Object
end

After do
  @driver.driver_quit
end