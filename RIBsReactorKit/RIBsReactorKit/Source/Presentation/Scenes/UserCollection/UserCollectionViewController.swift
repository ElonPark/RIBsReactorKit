//
//  UserCollectionViewController.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxSwift

protocol UserCollectionViewControllableListener: AnyObject {}

// MARK: - UserCollectionViewController

final class UserCollectionViewController: BaseViewController, UserCollectionViewControllable {

  // MARK: - Properties

  weak var listener: UserCollectionViewControllableListener?

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
      title: Strings.TabBarTitle.collection,
      image: Asset.Images.TabBarIcons.collectionTab.image,
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
