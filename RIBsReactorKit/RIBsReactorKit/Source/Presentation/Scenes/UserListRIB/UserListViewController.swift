//
//  UserListViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxSwift

protocol UserListPresentableListener: class {

}

final class UserListViewController:
  BaseViewController,
  UserListPresentable,
  UserListViewControllable
{
  
  // MARK: - Properties

  weak var listener: UserListPresentableListener?
  
  // MARK: - Initialization & Deinitialization

  override init() {
    super.init()
    setTabBarItem()
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Private methods
  
  private func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: "List",
      image: R.image.listTab(),
      selectedImage: nil
    )
  }
}
