//
//  BaseViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RxSwift

class BaseViewController:
  UIViewController,
  HasDisposeBag
{

  // MARK: - Properties
  
  var disposeBag: DisposeBag = DisposeBag()

  private(set) var didSetupConstraints: Bool = false
  
  // MARK: - Initialization & Deinitialization
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }
  
  deinit {
    Log.verbose(type(of: self))
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.setNeedsUpdateConstraints()
  }
  
  // MARK: - Inheritance
  
  // MARK: - Layout Constraints
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      setupConstraints()
      didSetupConstraints = true
    }
    
    super.updateViewConstraints()
  }
  
  /**
   Override this method, if need to set Autolayout constraints
   
   Do not call `setNeedsUpdateConstraints()` inside your implementation.
   Calling `setNeedsUpdateConstraints()` schedules another update pass, creating a feedback loop.
   
   Do not call `setNeedsLayout()`, `layoutIfNeeded()`, `setNeedsDisplay()` in this method
   */
  func setupConstraints() {
    // Override here
  }
}
