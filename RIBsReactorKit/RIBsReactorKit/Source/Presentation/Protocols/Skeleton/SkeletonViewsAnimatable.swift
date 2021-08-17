//
//  SkeletonViewsAnimatable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import SkeletonView

// MARK: - SkeletonViewsAnimatable

protocol SkeletonViewsAnimatable {
  var skeletonViews: [UIView] { get }

  func showSkeletonAnimation()
  func hideSkeletonAnimation()
}

extension SkeletonViewsAnimatable {
  func showSkeletonAnimation() {
    skeletonViews.forEach { $0.showAnimatedGradientSkeleton() }
  }

  func hideSkeletonAnimation() {
    skeletonViews
      .filter(\.isSkeletonActive)
      .forEach { $0.hideSkeleton(transition: .crossDissolve(0.25)) }
  }
}
