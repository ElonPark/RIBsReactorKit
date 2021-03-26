//
//  SkeletonAnimatable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import SkeletonView

// MARK: - SkeletonAnimatable

protocol SkeletonAnimatable {
  var views: [UIView] { get }

  func showSkeletonAnimation()
  func hideSkeletonAnimation()
}

extension SkeletonAnimatable {
  func showSkeletonAnimation() {
    views.forEach { $0.showAnimatedGradientSkeleton() }
  }

  func hideSkeletonAnimation() {
    views
      .filter(\.isSkeletonActive)
      .forEach { $0.hideSkeleton(transition: .crossDissolve(0.25)) }
  }
}
