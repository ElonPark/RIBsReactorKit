//
//  UserInfoSectionHeaderViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/18.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - UserInfoSectionHeaderViewModel

protocol UserInfoSectionHeaderViewModel {
  var title: String { get }
}

// MARK: - UserInfoSectionHeaderViewModelImpl

struct UserInfoSectionHeaderViewModelImpl: UserInfoSectionHeaderViewModel, Equatable {
  var title: String
}
