//
//  UserLocationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import CoreLocation
import RIBs

// MARK: - UserLocationDependency

protocol UserLocationDependency: Dependency {}

// MARK: - UserLocationComponent

final class UserLocationComponent: Component<UserLocationDependency> {

  fileprivate let initialState: UserLocationPresentableState

  init(annotationMetadata: MapPointAnnotationMetadata, dependency: UserLocationDependency) {
    self.initialState = UserLocationPresentableState(annotationMetadata: annotationMetadata)
    super.init(dependency: dependency)
  }
}

// MARK: - UserLocationBuildable

protocol UserLocationBuildable: Buildable {
  func build(
    annotationMetadata: MapPointAnnotationMetadata,
    withListener listener: UserLocationListener
  ) -> UserLocationRouting
}

// MARK: - UserLocationBuilder

final class UserLocationBuilder:
  Builder<UserLocationDependency>,
  UserLocationBuildable
{

  // MARK: - UserLocationBuildable

  func build(
    annotationMetadata: MapPointAnnotationMetadata,
    withListener listener: UserLocationListener
  ) -> UserLocationRouting {
    let component = UserLocationComponent(annotationMetadata: annotationMetadata, dependency: dependency)
    let viewController = UserLocationViewController()
    let interactor = UserLocationInteractor(
      initialState: component.initialState,
      presenter: viewController
    )
    interactor.listener = listener
    return UserLocationRouter(interactor: interactor, viewController: viewController)
  }
}
