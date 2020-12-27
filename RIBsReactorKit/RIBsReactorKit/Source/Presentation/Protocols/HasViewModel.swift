//
//  HasViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol HasViewModel {
  associatedtype ViewModel
  var viewModel: ViewModel? { get }
}
