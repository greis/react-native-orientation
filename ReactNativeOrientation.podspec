require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|

  s.name            = "ReactNativeOrientation"
  s.version         = version
  s.homepage        = "https://github.com/yamill/react-native-orientation"
  s.summary         = "Listen to device orientation changes in react-native and set preferred orientation on screen to screen basis."
  s.license         = "MIT"
  s.author          = { "Yamill Vallecillo" => "yamill@wpv.email" }
  s.platform        = :ios, "7.0"
  s.source          = { :git => "https://github.com/yamill/react-native-orientation.git", :tag => "#{s.version}" }
  s.source_files    = 'RCTOrientation/*.{h,m}'
  s.preserve_paths  = "**/*.js"

  s.dependency 'React'

end
