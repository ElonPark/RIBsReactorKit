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
  func push(viewController: ViewControllable, animated: Bool) {
    uiviewController.navigationController?.pushViewController(
      viewController.uiviewController,
      animated: animated
    )
  }
  
  func pop(animated: Bool) {
    uiviewController.navigationController?.popViewController(animated: animated)
  }
}
