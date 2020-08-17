//
//  BaseViewable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/18.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

protocol BaseViewable:
  UIView,
  HasSetupConstraints
{
  func initialize()
}
