//
//  HasConfigure.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol HasConfigure {
  associatedtype ViewModel
  func configure(by viewModel: ViewModel)
}
