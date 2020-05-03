//
//  UserCollectionViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxSwift

protocol UserCollectionPresentableListener: class {

}

final class UserCollectionViewController:
  BaseViewController,
  UserCollectionPresentable,
  UserCollectionViewControllable
{
  
  // MARK: - Properties

  weak var listener: UserCollectionPresentableListener?
  
  // MARK: - Initialization & Deinitialization
  
  override init() {
    super.init()
    setTabBarItem()
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTabBarItem()
  }
  
  // MARK: - Private methods
  
  private func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: "Collection",
      image: R.image.collectionTab(),
      selectedImage: nil
    )
  }
}
