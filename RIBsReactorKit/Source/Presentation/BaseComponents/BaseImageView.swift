//
//  BaseImageView.swift
//  RIBsReactorKit
//
//  Created by haskell on 2021/07/28.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import RxSwift

class BaseImageView:
  UIImageView,
  BaseViewable,
  HasDisposeBag
{

  // MARK: - Properties

  var disposeBag = DisposeBag()

  private(set) var didSetupConstraints: Bool = false

  // MARK: - Initialization & Deinitialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
  }

  override init(image: UIImage?) {
    super.init(image: image)
    self.initialize()
  }

  override init(image: UIImage?, highlightedImage: UIImage?) {
    super.init(image: image, highlightedImage: highlightedImage)
    self.initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Inheritance

  // MARK: - Layout Constraints

  override func updateConstraints() {
    self.setupConstraintsIfNeeded()
    super.updateConstraints()
  }

  // MARK: - Internal methods

  func initialize() {
    // Override point
    setNeedsUpdateConstraints()
  }

  func setupConstraints() {
    // Override here
  }

  // MARK: - Private methods

  private func setupConstraintsIfNeeded() {
    guard !self.didSetupConstraints else { return }
    self.setupConstraints()
    self.didSetupConstraints = true
  }
}
