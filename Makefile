setup:
	brew bundle
	bundle install
	make carthage_bootstrap
	make xcode_gen

setup_ci:
	brew bundle --file=Brewfile_ci
	make xcode_gen

carthage_bootstrap:
	carthage bootstrap --platform iOS --new-resolver --no-use-binaries --use-xcframeworks --cache-builds

carthage_update:
	carthage update --platform iOS --new-resolver --no-use-binaries --use-xcframeworks

xcode_gen:
	xcodegen generate

ribs_mock:
		mockolo -s ./Pods/RIBs/ios/RIBs/Classes -d ./RIBsReactorKitTests/RIBsMocks.swift --custom-imports RIBs

mock:
	mockolo -s ./RIBsReactorKit/Source \
	 --mockfiles ./RIBsReactorKitTests/RIBsMocks.swift \
	 -d ./RIBsReactorKitTests/OutputMocks.swift \
	 -i RIBsReactorKit \
	 --use-mock-observable \
	 --mock-final \
	 --exclude-imports Kingfisher MapKit NeedleFoundation RxCocoa RxDataSources RxViewController SkeletonView SwiftUI

setup_tree_viewer:
	(cd ./Scripts && sh install_server.sh)

show_tree_viewer:
	(cd ./Scripts && sh start_server.sh)

test:
	bundle exec fastlane ios ci_test

ci_test:
	fastlane ios ci_test