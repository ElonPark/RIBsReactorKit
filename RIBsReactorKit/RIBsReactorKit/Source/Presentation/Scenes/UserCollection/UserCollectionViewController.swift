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

protocol UserCollectionPresentableListener: class {}

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

#if canImport(SwiftUI) && DEBUG
import SwiftUI

private let deviceNames: [String] = [
  "iPhone SE",
  "iPhone 11 Pro Max"
]

@available(iOS 13.0, *)
struct UserCollectionControllerPreview: PreviewProvider {
  static var previews: some View {
    ForEach(deviceNames, id: \.self) { deviceName in
      UIViewControllerPreview {
        let viewController = UserCollectionViewController()
        return UINavigationController(rootViewController: viewController)
      }
      .previewDevice(PreviewDevice(rawValue: deviceName))
      .previewDisplayName(deviceName)
    }
  }
}
#endif
