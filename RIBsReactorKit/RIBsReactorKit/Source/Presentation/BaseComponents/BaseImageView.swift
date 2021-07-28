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
    initialize()
  }

  override init(image: UIImage?) {
    super.init(image: image)
    initialize()
  }

  override init(image: UIImage?, highlightedImage: UIImage?) {
    super.init(image: image, highlightedImage: highlightedImage)
    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    Log.verbose(type(of: self))
  }

  // MARK: - Inheritance

  // MARK: - Layout Constraints

  override func updateConstraints() {
    setupConstraintsIfNeeded()
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
    guard !didSetupConstraints else { return }
    setupConstraints()
    didSetupConstraints = true
  }
}
