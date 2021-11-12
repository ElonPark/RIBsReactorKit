//
//  UserInformationComponent+UserLocationUserLocation.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

protocol UserInformationDependencyUserLocation: Dependency {}

// MARK: - UserInformationComponent + UserLocationDependency

extension UserInformationComponent: UserLocationDependency {}
