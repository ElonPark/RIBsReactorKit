//
//  RootInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

protocol RootRouting: ViewableRouting {
  func attachMainTapBarRIB()
}

protocol RootPresentable: Presentable {
  var listener: RootPresentableListener? { get set }
}

protocol RootListener: class {}

final class RootInteractor:
  PresentableInteractor<RootPresentable>,
  RootInteractable,
  RootPresentableListener
{
  
  // MARK: - Properties
  
  weak var router: RootRouting?
  weak var listener: RootListener?

  let viewDidAppear: PublishRelay<Void>  = .init()
  
  // MARK: - Initialization & Deinitialization

  // in constructor.
  override init(presenter: RootPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
    
  // MARK: - Inheritance

  override func didBecomeActive() {
    super.didBecomeActive()
    bindViewDidAppear()
  }
  
  // MARK: - Private methods
  
  private func bindViewDidAppear() {
    viewDidAppear.bind {
      self.router?.attachMainTapBarRIB()
    }
    .disposeOnDeactivate(interactor: self)
  }
}

// MARK: - RootPresentableListener
extension RootInteractor {
  func viewWillAppear() {
    router?.attachMainTapBarRIB()
  }
}
