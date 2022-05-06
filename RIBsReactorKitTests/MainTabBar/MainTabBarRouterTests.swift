//
//  MainTabBarRouterTests.swift
//  RIBsReactorKitTests
//
//  Created by elon on 2022/05/02.
//  Copyright © 2022 Elon. All rights reserved.
//

@testable import RIBsReactorKit
import XCTest

import Nimble

// MARK: - MainTabBarRouterTests

final class MainTabBarRouterTests: XCTestCase {

  private var userListBuilder: UserListBuildableMock!
  private var userCollectionBuilder: UserCollectionBuildableMock!
  private var interactor: MainTabBarInteractableMock!
  private var viewController: MainTabBarViewControllableMock!
  private var router: MainTabBarRouter!

  // TODO: declare other objects and mocks you need as private vars

  override func setUp() {
    super.setUp()
    self.userListBuilder = .init()
    self.userCollectionBuilder = .init()
    self.interactor = .init()
    self.viewController = .init()

    self.router = .init(
      userListBuilder: self.userListBuilder,
      userCollectionBuilder: self.userCollectionBuilder,
      interactor: self.interactor,
      viewController: self.viewController
    )
  }
}

// MARK: - Tests

extension MainTabBarRouterTests {
  func test_when_attachTabs_called_it_should_be_call_build_from_builders() {
    // when
    self.router.attachTabs()

    // then
    expect(self.userListBuilder.buildCallCount) == 1
    expect(self.userCollectionBuilder.buildCallCount) == 1
    expect(self.viewController.setViewControllersCallCount) == 1
    expect(self.router.children.count) == 2
  }
}
