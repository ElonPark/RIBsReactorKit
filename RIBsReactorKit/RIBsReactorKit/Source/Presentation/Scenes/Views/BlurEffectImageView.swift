//
//  BlurEffectImageView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import SnapKit

final class BlurEffectImageView: UIImageView {

  // MARK: - Properties

  var blurStyle: UIBlurEffect.Style = .light {
    didSet {
      blurView.effect = UIBlurEffect(style: blurStyle)
    }
  }

  // MARK: - UI Components

  private let blurView = UIVisualEffectView()

  // MARK: - Initialization & Deinitialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  override init(image: UIImage?) {
    super.init(image: image)
    setupUI()
  }

  override init(image: UIImage?, highlightedImage: UIImage?) {
    super.init(image: image, highlightedImage: highlightedImage)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout

extension BlurEffectImageView {
  private func setupUI() {
    addSubview(blurView)

    layout()
  }

  private func layout() {
    blurView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
