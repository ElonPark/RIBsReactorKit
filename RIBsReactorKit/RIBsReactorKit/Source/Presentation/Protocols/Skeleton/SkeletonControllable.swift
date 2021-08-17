//
//  SkeletonControllable.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import SkeletonView

// MARK: - SkeletonControllable

protocol SkeletonControllable {
  func skeletonView(_ contentsView: UIView, shouldStartAnimationWhen needAnimation: Bool)
}

extension SkeletonControllable {
  func skeletonView(_ contentsView: UIView, shouldStartAnimationWhen needAnimation: Bool) {
    DispatchQueue.main.async { [weak contentsView] in
      if needAnimation {
        contentsView?.showAnimatedGradientSkeleton()
      } else {
        contentsView?.hideSkeleton(transition: .crossDissolve(0.25))
      }
    }
  }
}
