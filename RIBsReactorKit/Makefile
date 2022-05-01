setup:
	brew bundle
	$$(make bootstrap)
	$$(make xcodegen)
	$$(make clean_unuse_libs)

bootstrap:
	carthage bootstrap --platform iOS --new-resolver --no-use-binaries --use-xcframeworks

update:
	carthage update --platform iOS --new-resolver --no-use-binaries --use-xcframeworks

xcodegen:
	xcodegen generate

clean_unuse_libs:
	rm -rf ./Carthage/Checkouts/ReactiveSwift
	rm -rf ./Carthage/Build/iOS/ReactiveSwift.*
	rm -rf ./Carthage/Build/iOS/ReactiveMoya.*

setup_tree_viewer:
	(cd ./Scripts && sh install_server.sh)

show_tree_viewer:
	(cd ./Scripts && sh start_server.sh)
