//
//  UserCollectionRouter.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

// MARK: - UserCollectionInteractable

protocol UserCollectionInteractable: Interactable {
  var router: UserCollectionRouting? { get set }
  var listener: UserCollectionListener? { get set }
}

// MARK: - UserCollectionViewControllable

protocol UserCollectionViewControllable: ViewControllable {
  var listener: UserCollectionViewControllableListener? { get set }
}

// MARK: - UserCollectionRouter

final class UserCollectionRouter:
  ViewableRouter<UserCollectionInteractable, UserCollectionViewControllable>,
  UserCollectionRouting
{

  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: UserCollectionInteractable, viewController: UserCollectionViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
