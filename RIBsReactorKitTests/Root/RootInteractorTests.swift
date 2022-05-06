//
//  RootInteractorTests.swift
//  RIBsReactorKitTests
//
//  Created by elon on 2022/05/01.
//  Copyright © 2022 Elon. All rights reserved.
//

@testable import RIBsReactorKit
import XCTest

import Nimble

// MARK: - RootInteractorTests

final class RootInteractorTests: XCTestCase {

  private var interactor: RootInteractor!

  private var router: RootRoutingMock!
  private var listener: RootListenerMock!

  override func setUp() {
    super.setUp()
    self.router = RootRoutingMock()
    self.listener = RootListenerMock()

    self.interactor = RootInteractor()
    self.interactor.router = self.router
    self.interactor.listener = self.listener
  }
}

// MARK: - Tests

extension RootInteractorTests {
  func test_when_didBecomeActive_called_it_should_be_call_attachMainTabBarRIB_from_router() {
    // when
    self.interactor.didBecomeActive()

    // then
    expect(self.router.attachMainTabBarRIBCallCount) == 1
  }

  func test_when_willResignActive_called_it_should_be_call_cleanupViews_from_router() {
    // when
    self.interactor.willResignActive()

    // then
    expect(self.router.cleanupViewsCallCount) == 1
  }
}
