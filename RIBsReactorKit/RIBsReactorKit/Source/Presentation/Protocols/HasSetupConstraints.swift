//
//  HasSetupConstraints.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/18.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol HasSetupConstraints {
  var didSetupConstraints: Bool { get }
 
  /**
   Override this method, if need to set Autolayout constraints
   
   Do not call `setNeedsUpdateConstraints()` inside your implementation.
   Calling `setNeedsUpdateConstraints()` schedules another update pass, creating a feedback loop.
   
   Do not call `setNeedsLayout()`, `layoutIfNeeded()`, `setNeedsDisplay()` in this method
   */
  func setupConstraints()
}
