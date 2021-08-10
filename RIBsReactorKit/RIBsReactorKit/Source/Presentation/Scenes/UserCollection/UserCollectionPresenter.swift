//
//  UserCollectionPresenter.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

// MARK: - UserCollectionPresentableListener

protocol UserCollectionPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

// MARK: - UserCollectionPresenter

final class UserCollectionPresenter: Presenter<UserCollectionViewControllable>, UserCollectionPresentable,
UserCollectionViewControllableListener {

  weak var listener: UserCollectionPresentableListener?

  override init(viewController: UserCollectionViewControllable) {
    super.init(viewController: viewController)
    viewController.listener = self
  }
}
