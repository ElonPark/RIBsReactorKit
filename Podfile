platform :ios, '13.0'

plugin 'cocoapods-binary-cache'

config_cocoapods_binary_cache(
  cache_repo: {
    'default' => {
      'remote' => 'git@github.com:ElonPark/RIBsReactorKit-CocoapodsBinaryCache.git',
      'local' => '~/.cocoapods-binary-cache/prebuilt-frameworks'
    }
  },
  prebuild_config: 'Debug',
  device_build_enabled: true
)

target 'RIBsReactorKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for RIBsReactorKit

  # Architecture
  pod 'RIBs', :git => 'https://github.com/ElonPark/RIBs.git', :branch => 'mockolo', :binary => true
  pod 'ReactorKit', :binary => true

  # DI
  pod 'NeedleFoundation', :binary => true

  # Rx
  pod 'RxSwift', :binary => true
  pod 'RxCocoa', :binary => true

  # Network
  pod 'Alamofire', :binary => true
  pod 'Moya/RxSwift', '~> 15.0', :binary => true
  pod 'RxReachability', '~> 1.2.1', :binary => true

  # UI
  pod 'SnapKit', :binary => true
  pod 'SkeletonView', :binary => true
  pod 'RxDataSources', :binary => true
  pod 'RxViewController', :binary => true

  # Image
  pod 'Kingfisher', :binary => true

  # ETC
  pod 'EPLogger', :binary => true

  target 'RIBsReactorKitTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble', :binary => true
    pod 'RxBlocking', :binary => true
    pod 'RxTest', :binary => true
  end

  target 'RIBsReactorKitUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"

      if Gem::Version.new('12.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end