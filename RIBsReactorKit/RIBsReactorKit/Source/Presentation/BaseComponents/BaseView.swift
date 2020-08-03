//
//  BaseView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RxSwift

class BaseView:
  UIView,
  HasDisposeBag
{
  
   // MARK: - Properties
  
  var disposeBag: DisposeBag = DisposeBag()
  
  private(set) var didSetupConstraints: Bool = false
  
  // MARK: - Initialization & Deinitialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setNeedsUpdateConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  deinit {
    Log.verbose(type(of: self))
  }
  
  // MARK: - Inheritance
  
  // MARK: - Layout Constraints
  
  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    
    super.updateConstraints()
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
