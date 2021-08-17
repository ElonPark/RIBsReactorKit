//
//  BaseViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RxRelay
import RxSwift

class BaseViewController:
  UIViewController,
  HasSetupConstraints,
  HasDetachAction,
  HasDisposeBag
{

  // MARK: - Properties

  let detachAction = PublishRelay<Void>()
  var disposeBag = DisposeBag()

  private(set) var didSetupConstraints: Bool = false

  // MARK: - Initialization & Deinitialization

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    Log.verbose(type(of: self))
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.setNeedsUpdateConstraints()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    guard isMovingFromParent || isBeingDismissed else { return }
    detachAction.accept(Void())
  }

  // MARK: - Inheritance

  // MARK: - Layout Constraints

  override func updateViewConstraints() {
    setupConstraintsIfNeeded()
    super.updateViewConstraints()
  }

  // MARK: - Internal methods

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
