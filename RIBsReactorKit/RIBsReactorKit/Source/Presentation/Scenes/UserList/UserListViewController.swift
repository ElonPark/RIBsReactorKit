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
  
  enum Action {
    case refresh
    case loadMore
    case itemSelected(IndexPath)
  }
  
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

#if canImport(SwiftUI) && DEBUG
import SwiftUI

private let deviceNames: [String] = [
  "iPhone SE",
  "iPhone 11 Pro Max"
]

@available(iOS 13.0, *)
struct UserListViewControllerPreview: PreviewProvider {
  static var previews: some View {
    ForEach(deviceNames, id: \.self) { deviceName in
      UIViewControllerPreview {
        let viewController = UserListViewController()
        return UINavigationController(rootViewController: viewController)
      }
      .previewDevice(PreviewDevice(rawValue: deviceName))
      .previewDisplayName(deviceName)
    }
  }
}
#endif
