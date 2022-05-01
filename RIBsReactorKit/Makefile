setup:
	brew bundle
	$$(make bootstrap)
	$$(make xcode_gen)
	$$(make clean_unuse_libs)

bootstrap:
	carthage bootstrap --platform iOS --new-resolver --no-use-binaries --use-xcframeworks

update:
	carthage update --platform iOS --new-resolver --no-use-binaries --use-xcframeworks --cache-builds

xcode_gen:
	xcodegen generate

ribs_mock:
		mockolo -s ./Carthage/Checkouts/RIBs/ios/RIBs/Classes -d ./RIBsReactorKitTests/RIBsMocks.swift --custom-imports RIBs

# make mock rib=RIB_NAME
mock_riblet:
	mockolo -s ./RIBsReactorKit/Source/Presentation/Scenes/$(rib) \
	 --mockfiles ./RIBsReactorKitTests/RIBsMocks.swift \
	 -d ./RIBsReactorKitTests/$(rib)/$(rib)Mocks.swift \
	 -i RIBsReactorKit \
	 --use-mock-observable \
	 --mock-final

clean_unuse_libs:
	rm -rf ./Carthage/Checkouts/ReactiveSwift
	rm -rf ./Carthage/Build/iOS/ReactiveSwift.*
	rm -rf ./Carthage/Build/iOS/ReactiveMoya.*

setup_tree_viewer:
	(cd ./Scripts && sh install_server.sh)

show_tree_viewer:
	(cd ./Scripts && sh start_server.sh)
