//
//  RootRouter.swift
//  Smithsonian
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
  func present(viewController: ViewControllable)
  func dismiss(viewController: ViewControllable)
}

final class RootRouter:
  LaunchRouter<RootInteractable, RootViewControllable>,
  RootRouting
{
  
  // MARK: - Initialization & Deinitialization

  override init(
    interactor: RootInteractable,
    viewController: RootViewControllable
  ) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  // MARK: - Inheritance
  
  override func didLoad() {
    super.didLoad()
  }
}
