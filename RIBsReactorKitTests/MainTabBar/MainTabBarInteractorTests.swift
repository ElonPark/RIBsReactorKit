//
//  MainTabBarInteractorTests.swift
//  RIBsReactorKitTests
//
//  Created by elon on 2022/05/02.
//  Copyright © 2022 Elon. All rights reserved.
//

@testable import RIBsReactorKit
import XCTest

import Nimble

final class MainTabBarInteractorTests: XCTestCase {

  private var presenter: MainTabBarPresentableMock!
  private var router: MainTabBarRoutingMock!
  private var listener: MainTabBarListenerMock!
  private var interactor: MainTabBarInteractor!

  // TODO: declare other objects and mocks you need as private vars

  override func setUp() {
    super.setUp()
    self.presenter = MainTabBarPresentableMock()
    self.router = MainTabBarRoutingMock()
    self.listener = MainTabBarListenerMock()

    self.interactor = MainTabBarInteractor(
      presenter: self.presenter
    )
    self.interactor.router = self.router
    self.interactor.listener = self.listener
  }
}


// MARK: - Tests

extension MainTabBarInteractorTests {
  func test_when_didBecomeActive_called_it_should_be_call_attachTabs_from_router() {
    // when
    self.interactor.didBecomeActive()

    // then
    expect(self.router.attachTabsCallCount) == 1
  }
}
