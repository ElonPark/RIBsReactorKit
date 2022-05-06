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
    uiviewController as? UIKit.UINavigationController ?? uiviewController.navigationController
  }

  func push(
    viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    shouldHidesBottomBarWhenPushed: Bool = true,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    if shouldHidesBottomBarWhenPushed {
      self.setHidesBottomBarWhenPushed(to: viewController)
    }

    self.checkPresentedViewController(
      of: self,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
    ) { [weak self] in
      self?.navigationController?.pushViewController(
        viewController.uiviewController,
        animated: animated
      )
      completion?()
    }
  }

  private func setHidesBottomBarWhenPushed(to viewController: ViewControllable) {
    // iOS 14.0, 14.1 BottomBar bug https://developer.apple.com/forums/thread/660750
    let canHideBottomBarWhenPushed = self.navigationController?.viewControllers.count == 1
    viewController.uiviewController.hidesBottomBarWhenPushed = canHideBottomBarWhenPushed
  }

  func pop(
    _ viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    guard !viewController.uiviewController.isMovingFromParent else { return }
    if uiviewController is UIKit.UINavigationController {
      self.pop(
        viewController: viewController,
        animated: animated,
        completion: completion,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
      )
    } else {
      self.pop(
        to: self,
        animated: animated,
        completion: completion,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
      )
    }
  }

  func pop(
    to viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    self.checkPresentedViewController(
      of: viewController,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
    ) { [weak self] in
      self?.navigationController?.popToViewController(
        viewController.uiviewController,
        animated: animated
      )
      completion?()
    }
  }

  private func pop(
    viewController: ViewControllable,
    animated: Bool,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool,
    presentedViewControllerDismissAnimated: Bool
  ) {
    self.checkPresentedViewController(
      of: viewController,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
    ) {
      viewController.uiviewController.navigationController?.popViewController(animated: animated)
      completion?()
    }
  }

  func popToRootViewController(
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    self.checkPresentedViewController(
      of: self,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
    ) { [weak self] in
      self?.navigationController?.popToRootViewController(animated: animated)
      completion?()
    }
  }

  func present(
    _ viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    self.checkPresentedViewController(
      of: self,
      needToDismissPresentedViewController: needToDismissPresentedViewController,
      presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
    ) { [weak self] in
      self?.uiviewController.present(
        viewController.uiviewController,
        animated: animated,
        completion: completion
      )
    }
  }

  func show(
    _ viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    shouldHidesBottomBarWhenPushed: Bool = true,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    if self.navigationController != nil {
      self.push(
        viewController: viewController,
        animated: animated,
        completion: completion,
        shouldHidesBottomBarWhenPushed: shouldHidesBottomBarWhenPushed,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
      )
    } else {
      self.present(
        viewController,
        animated: animated,
        completion: completion,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
      )
    }
  }

  func remove(
    _ viewController: ViewControllable,
    animated: Bool = true,
    completion: (() -> Void)? = nil,
    needToDismissPresentedViewController: Bool = true,
    presentedViewControllerDismissAnimated: Bool = false
  ) {
    if self.navigationController != nil {
      self.pop(
        viewController,
        animated: animated,
        completion: completion,
        needToDismissPresentedViewController: needToDismissPresentedViewController,
        presentedViewControllerDismissAnimated: presentedViewControllerDismissAnimated
      )
    } else {
      self.dismiss(viewController, animated: animated, completion: completion)
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
    presentedViewControllerDismissAnimated: Bool,
    completion: (() -> Void)?
  ) {
    if needToDismissPresentedViewController,
       let presentedViewController = viewController.uiviewController.presentedViewController
    {
      presentedViewController.dismiss(animated: presentedViewControllerDismissAnimated, completion: completion)
    } else {
      completion?()
    }
  }
}
