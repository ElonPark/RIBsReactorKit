Pod::Spec.new do |s|
  s.name             = "WeakMapTable"
  s.version          = "1.1.0"
  s.summary          = "A weak-to-strong map table"
  s.homepage         = "https://github.com/ReactorKit/WeakMapTable"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Suyeol Jeon" => "devxoul@gmail.com" }
  s.source           = { :git => "https://github.com/ReactorKit/WeakMapTable.git",
                         :tag => s.version.to_s }
  s.source_files = "Sources/**/*.{swift,h,m}"
  s.frameworks   = "Foundation"
  s.swift_version = "5.1"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.11"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "3.0"
end
