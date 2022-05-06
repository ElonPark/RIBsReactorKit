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
      self.blurView.effect = UIBlurEffect(style: self.blurStyle)
    }
  }

  // MARK: - UI Components

  private let blurView = UIVisualEffectView()

  override func initialize() {
    super.initialize()
    addSubview(self.blurView)
  }

  override func setupConstraints() {
    super.setupConstraints()
    self.makeBlurViewConstraints()
  }

  private func makeBlurViewConstraints() {
    self.blurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
