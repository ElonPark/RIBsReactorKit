setup:
	brew bundle
	bundle install
	make xcode_gen

setup_ci:
	brew bundle --file=Brewfile_ci
	make xcode_gen

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

test:
	bundle exec fastlane ios ci_test

ci_test:
	fastlane ios ci_test