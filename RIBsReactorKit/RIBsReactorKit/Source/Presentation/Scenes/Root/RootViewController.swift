//
//  RootViewController.swift
//  Smithsonian
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs

protocol RootPresentableListener: class {}

final class RootViewController:
  BaseViewController,
  RootPresentable,
  RootViewControllable
{
  
  // MARK: - Properties
  
  weak var listener: RootPresentableListener?
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  // MARK: - RootViewControllable
  
  func present(viewController: ViewControllable, animated: Bool) {
    present(viewController.uiviewController, animated: animated)
  }
  
  func dismiss(viewController: ViewControllable, animated: Bool) {
    guard presentedViewController === viewController.uiviewController else { return }
    dismiss(animated: true, completion: nil)
  }
}
