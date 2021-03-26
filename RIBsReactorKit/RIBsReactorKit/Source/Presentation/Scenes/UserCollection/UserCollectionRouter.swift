//
//  UserCollectionRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - UserCollectionInteractable

protocol UserCollectionInteractable: Interactable {
  var router: UserCollectionRouting? { get set }
  var listener: UserCollectionListener? { get set }
}

protocol UserCollectionViewControllable: ViewControllable {}

// MARK: - UserCollectionRouter

final class UserCollectionRouter:
  ViewableRouter<UserCollectionInteractable, UserCollectionViewControllable>,
  UserCollectionRouting
{

  // MARK: - Initialization & Deinitialization

  override init(
    interactor: UserCollectionInteractable,
    viewController: UserCollectionViewControllable
  ) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
