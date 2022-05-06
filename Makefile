setup:
	brew bundle
	bundle install
	make bootstrap
	make xcode_gen
	make clean_unuse_libs

setup_ci:
	brew bundle --file=Brewfile_ci
	make bootstrap
	make xcode_gen
	make clean_unuse_libs

bootstrap:
	rome download --platform iOS
	carthage bootstrap --platform iOS --new-resolver --no-use-binaries --use-xcframeworks --cache-builds
	rome list --missing --platform iOS | awk '{print $1}' | xargs -I {} rome upload "{}" --platform iOS

update:
	carthage update --platform iOS --new-resolver --no-use-binaries --use-xcframeworks --cache-builds
	rome list --missing --platform iOS | awk '{print $1}' | xargs -I {} rome upload "{}" --platform iOS

xcode_gen:
	xcodegen generate

ribs_mock:
		mockolo -s ./Carthage/Checkouts/RIBs/ios/RIBs/Classes -d ./RIBsReactorKitTests/RIBsMocks.swift --custom-imports RIBs

mock:
	mockolo -s ./RIBsReactorKit/Source \
	 --mockfiles ./RIBsReactorKitTests/RIBsMocks.swift \
	 -d ./RIBsReactorKitTests/OutputMocks.swift \
	 -i RIBsReactorKit \
	 --use-mock-observable \
	 --mock-final \
	 --exclude-imports Kingfisher MapKit NeedleFoundation RxCocoa RxDataSources RxViewController SkeletonView SwiftUI

clean_unuse_libs:
	rm -rf ./Carthage/Checkouts/ReactiveSwift
	rm -rf ./Carthage/Build/iOS/ReactiveSwift.*
	rm -rf ./Carthage/Build/iOS/ReactiveMoya.*

setup_tree_viewer:
	(cd ./Scripts && sh install_server.sh)

show_tree_viewer:
	(cd ./Scripts && sh start_server.sh)

test:
	bundle exec fastlane ios ci_test