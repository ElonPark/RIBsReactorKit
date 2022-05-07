platform :ios, '13.0'

target 'RIBsReactorKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for RIBsReactorKit

  # Architecture
  pod 'RIBs', :git => 'https://github.com/ElonPark/RIBs.git', :branch => 'mockolo'
  pod 'ReactorKit'

  # DI
  pod 'NeedleFoundation'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'

  # Network
  pod 'Alamofire'
  pod 'Moya/RxSwift', '~> 15.0'
  pod 'RxReachability', '~> 1.2.1'

  # UI
  pod 'SnapKit'
  pod 'SkeletonView'
  pod 'RxDataSources'
  pod 'RxViewController'

  # Image
  pod 'Kingfisher'

  # ETC
  pod 'EPLogger'

  target 'RIBsReactorKitTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble'
    pod 'RxBlocking'
    pod 'RxTest'
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