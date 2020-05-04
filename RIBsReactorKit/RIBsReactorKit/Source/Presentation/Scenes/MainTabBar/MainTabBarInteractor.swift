//
//  MainTabBarInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift

protocol MainTabBarRouting: ViewableRouting {
  func attachUserListRIB()
  func attachUserCollectionRIB()
}

protocol MainTabBarPresentable: Presentable {
  var listener: MainTabBarPresentableListener? { get set }
}

protocol MainTabBarListener: class {

}

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
    
  }
  
  override func willResignActive() {
    super.willResignActive()
    
  }
}
