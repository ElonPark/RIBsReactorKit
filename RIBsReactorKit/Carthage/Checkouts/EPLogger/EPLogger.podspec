#
# Be sure to run `pod lib lint EPLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EPLogger'
  s.version          = '1.3.4'
  s.summary          = 'Just simple Logger'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Just simple Logger

```swift

   // Log level. default is verbose
   Log.config(level: .debug)

   Log.verbose("verbose")
   Log.debug("debug")
   Log.warning("warning")
   Log.error("error")
```
                       DESC

  s.homepage         = 'https://github.com/ElonPark/EPLogger'
  s.screenshots      = 'https://user-images.githubusercontent.com/13270453/63907154-59416680-ca55-11e9-888c-3bbc2cde6f68.png',
                       'https://user-images.githubusercontent.com/13270453/77232955-8c149d00-6be7-11ea-9396-773b36996e98.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elon Park' => 'sungwoon.park92@gmail.com' }
  s.source           = { :git => 'https://github.com/ElonPark/EPLogger.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_versions = '5.0'
  s.source_files = 'EPLogger/Classes/*'

end
