//
//  MainTabBarViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxSwift

protocol MainTabBarPresentableListener: class {

}

final class MainTabBarViewController:
  UITabBarController,
  MainTabBarPresentable,
  MainTabBarViewControllable
{
  
  // MARK: - Properties
  
  weak var listener: MainTabBarPresentableListener?
  
  // MARK: - Initialization & Deinitialization

  init(viewControllers: [UINavigationController]) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .fullScreen
    setViewControllers(viewControllers, animated: false)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

private let deviceNames: [String] = [
  "iPhone SE",
  "iPhone 11 Pro Max"
]

@available(iOS 13.0, *)
struct MainTabBarViewControllerPreview: PreviewProvider {
  static var previews: some View {
    ForEach(deviceNames, id: \.self) { deviceName in
      UIViewControllerPreview {
        let viewControllers = [
          UserListViewController(),
          UserCollectionViewController()
        ].map { UINavigationController(rootViewController: $0) }
    
        return MainTabBarViewController(viewControllers: viewControllers)
      }
      .previewDevice(PreviewDevice(rawValue: deviceName))
      .previewDisplayName(deviceName)
    }
  }
}
#endif
