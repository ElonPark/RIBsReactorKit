//
//  BlurEffectImageView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import SnapKit

// MARK: - BlurEffectImageView

final class BlurEffectImageView: BaseImageView {

  // MARK: - Properties

  var blurStyle: UIBlurEffect.Style = .light {
    didSet {
      blurView.effect = UIBlurEffect(style: blurStyle)
    }
  }

  // MARK: - UI Components

  private let blurView = UIVisualEffectView()

  override func initialize() {
    super.initialize()
    addSubview(blurView)
  }

  override func setupConstraints() {
    super.setupConstraints()
    makeBlurViewConstraints()
  }

  private func makeBlurViewConstraints() {
    blurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
