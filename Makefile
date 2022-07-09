setup:
	brew bundle
	bundle install
	make xcode_gen
	make pod_install

setup_ci:
	brew bundle --file=Brewfile_ci
	bundle install
	make xcode_gen
	make pod_install

install_rbenv:
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
	echo 'eval "$(rbenv init -)"' >> ~/.zshrc
	rbenv install $$(make ruby_version)
	rbenv local $$(make ruby_version)

ruby_version:
	@echo `cat .ruby-version`

project:
	make xcode_gen
	bundle exec pod install

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

# https://github.com/grab/cocoapods-binary-cache/pull/86
pod_install:
	bundle exec pod binary prebuild "swift$$(make swift_version)-$$(make podfile_lock_checksum)" --no-fetch
	bundle exec pod binary fetch "swift$$(make swift_version)-$$(make podfile_lock_checksum)"
	bundle exec pod binary push "swift$$(make swift_version)-$$(make podfile_lock_checksum)"

pod_update:
	bundle exec pod update
	bundle exec pod binary prebuild --no-fetch --all || bundle exec pod binary prebuild --repo-update --no-fetch --all
	bundle exec pod binary push "swift-$$(make swift_version)-$$(make podfile_lock_checksum)"

swift_version:
	@echo `swift --version 2>/dev/null | sed -ne 's/^Apple Swift version \([^\b ]*\).*/\1/p'`

podfile_lock_checksum:
	@echo `sed -ne '/PODFILE CHECKSUM: /p' Podfile.lock | sed s'/$ PODFILE CHECKSUM: '//`