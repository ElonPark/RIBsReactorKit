//
//  ViewControllableExtensions.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/05.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs

extension ViewControllable {
  private var navigationController: UIKit.UINavigationController? {
    if uiviewController is UIKit.UINavigationController {
      return uiviewController as? UIKit.UINavigationController
    } else {
      return uiviewController.navigationController
    }
  }

  func push(viewController: ViewControllable, animated: Bool = true) {
    navigationController?.pushViewController(
      viewController.uiviewController,
      animated: animated
    )
  }

  func pop(
    _ viewController: ViewControllable,
    animated: Bool = true,
    needToDismissPresentedViewController: Bool = true,
    dismissAnimated: Bool = false
  ) {
    guard !viewController.uiviewController.isMovingFromParent else { return }
    if uiviewController is UIKit.UINavigationController {
      pop(
        viewController: viewController,
        animated: animated,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        dismissAnimated: dismissAnimated
      )
    } else {
      pop(
        to: self,
        animated: animated,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        dismissAnimated: dismissAnimated
      )
    }
  }

  func pop(
    to viewController: ViewControllable,
    animated: Bool = true,
    needToDismissPresentedViewController: Bool = true,
    dismissAnimated: Bool = false
  ) {
    checkPresentedViewController(
      of: viewController,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      dismissAnimated: dismissAnimated
    ) { [weak self] in
      self?.navigationController?.popToViewController(
        viewController.uiviewController,
        animated: animated
      )
    }
  }

  private func pop(
    viewController: ViewControllable,
    animated: Bool,
    needToDismissPresentedViewController: Bool,
    dismissAnimated: Bool
  ) {
    checkPresentedViewController(
      of: viewController,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      dismissAnimated: dismissAnimated
    ) {
      viewController.uiviewController.navigationController?.popViewController(animated: animated)
    }
  }

  func popToRootViewController(
    animated: Bool = true,
    needToDismissPresentedViewController: Bool = true,
    dismissAnimated: Bool = false
  ) {
    checkPresentedViewController(
      of: self,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      dismissAnimated: dismissAnimated
    ) { [weak self] in
      self?.navigationController?.popToRootViewController(animated: animated)
    }
  }

  func present(
    _ viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    checkPresentedViewController(
      of: self,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      dismissAnimated: presentedViewControllerDismissAnimated
    ) { [weak self] in
      self?.uiviewController.present(
        viewController.uiviewController,
        animated: animated,
        completion: completion
      )
    }
  }

  func dismiss(
    _ viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    guard !viewController.uiviewController.isBeingDismissed else {
      completion?()
      return
    }

    viewController.uiviewController.dismiss(
      animated: animated,
      completion: completion
    )
  }

  func dismissPresentedViewController(
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    if let presentedViewController = uiviewController.presentedViewController {
      presentedViewController.dismiss(animated: animated, completion: completion)
    } else {
      completion?()
    }
  }

  private func checkPresentedViewController(
    of viewController: ViewControllable,
    needToDismissPresentedViewController: Bool,
    dismissAnimated: Bool,
    completion: (() -> Void)?
  ) {
    if needToDismissPresentedViewController,
       let presentedViewController = viewController.uiviewController.presentedViewController
    {
      presentedViewController.dismiss(animated: dismissAnimated, completion: completion)
    } else {
      completion?()
    }
  }
}
