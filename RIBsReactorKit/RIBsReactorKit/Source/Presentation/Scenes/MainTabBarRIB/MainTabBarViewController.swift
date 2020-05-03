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

extension MainTabBarViewController {
  func push(viewController: ViewControllable, animated: Bool) {
    navigationController?.pushViewController(viewController.uiviewController, animated: animated)
  }
  
  func pop(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }
  
  func pop(to viewController: ViewControllable, animated: Bool) {
    navigationController?.popToViewController(viewController.uiviewController, animated: animated)
  }
}
