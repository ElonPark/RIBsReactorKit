//
//  RootRouterTests.swift
//  RIBsReactorKitTests
//
//  Created by elon on 2022/05/01.
//  Copyright © 2022 Elon. All rights reserved.
//

@testable import RIBsReactorKit
import XCTest

import Nimble

// MARK: - RootRouterTests

final class RootRouterTests: XCTestCase {

  private var router: RootRouter!

  private var mainTabBarBuilder: MainTabBarBuildableMock!
  private var interactor: RootInteractableMock!
  private var viewController: RootViewControllableMock!

  override func setUp() {
    super.setUp()
    self.mainTabBarBuilder = MainTabBarBuildableMock()
    self.interactor = RootInteractableMock()
    self.viewController = RootViewControllableMock()

    self.router = RootRouter(
      mainTabBarBuilder: self.mainTabBarBuilder,
      interactor: self.interactor,
      viewController: self.viewController
    )
  }
}

extension RootRouterTests {
  func test_when_attachMainTabBarRIB_called_it_should_be_build_mainTabBar() {
    // when
    self.router.attachMainTabBarRIB()

    // then
    expect(self.mainTabBarBuilder.buildCallCount) == 1
  }

  func test_when_cleanupViews_called_it_should_be_detach_all_children() {
    // given
    self.router.attachMainTabBarRIB()

    // when
    self.router.cleanupViews()

    // then
    expect(self.router.children.isEmpty) == true
  }
}
