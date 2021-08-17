//
//  UserCollectionViewModel.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

struct UserCollectionViewModel: PropertyBuilderCompatible, HasLoadingState, HasRefreshState {
  var isLoading: Bool = false
  var isRefresh: Bool = false
  var userCollectionSections = [UserCollectionSectionModel]()
}
