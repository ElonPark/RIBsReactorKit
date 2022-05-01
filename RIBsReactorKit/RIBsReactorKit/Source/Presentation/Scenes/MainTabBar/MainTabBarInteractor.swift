//
//  MainTabBarInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift

// MARK: - MainTabBarRouting

/// @mockable
protocol MainTabBarRouting: ViewableRouting {
  func attachTabs()
}

// MARK: - MainTabBarPresentable

protocol MainTabBarPresentable: Presentable {
  var listener: MainTabBarPresentableListener? { get set }
}

protocol MainTabBarListener: AnyObject {}

// MARK: - MainTabBarInteractor

final class MainTabBarInteractor:
  PresentableInteractor<MainTabBarPresentable>,
  MainTabBarInteractable,
  MainTabBarPresentableListener
{

  // MARK: - Properties

  weak var router: MainTabBarRouting?
  weak var listener: MainTabBarListener?

  // MARK: - Initialization & Deinitialization

  override init(presenter: MainTabBarPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }

  // MARK: - Inheritance

  override func didBecomeActive() {
    super.didBecomeActive()
    router?.attachTabs()
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
