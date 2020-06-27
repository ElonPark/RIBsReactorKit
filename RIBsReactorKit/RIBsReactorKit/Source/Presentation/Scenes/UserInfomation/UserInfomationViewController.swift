//
//  UserInfomationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol UserInfomationPresentableListener: class {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class UserInfomationViewController: UIViewController, UserInfomationPresentable, UserInfomationViewControllable {
  
  weak var listener: UserInfomationPresentableListener?
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
}
