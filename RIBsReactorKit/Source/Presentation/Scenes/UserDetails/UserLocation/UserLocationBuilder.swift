//
//  UserLocationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import CoreLocation

import NeedleFoundation
import RIBs

// MARK: - UserLocationDependency

protocol UserLocationDependency: NeedleFoundation.Dependency {}

// MARK: - UserLocationBuildDependency

struct UserLocationBuildDependency {
  let listener: UserLocationListener
}

// MARK: - UserLocationComponentDependency

struct UserLocationComponentDependency {
  let annotationMetadata: MapPointAnnotationMetadata
}

// MARK: - UserLocationComponent

final class UserLocationComponent: NeedleFoundation.Component<UserLocationDependency> {

  fileprivate var initialState: UserLocationPresentableState {
    UserLocationPresentableState(
      annotationMetadata: self.payload.annotationMetadata
    )
  }

  private let payload: UserLocationComponentDependency

  init(parent: Scope, payload: UserLocationComponentDependency) {
    self.payload = payload
    super.init(parent: parent)
  }
}

// MARK: - UserLocationBuildable

protocol UserLocationBuildable: Buildable {
  func build(
    with dynamicBuildDependency: UserLocationBuildDependency,
    _ dynamicComponentDependency: UserLocationComponentDependency
  ) -> UserLocationRouting
}

// MARK: - UserLocationBuilder

final class UserLocationBuilder:
  ComponentizedBuilder<
    UserLocationComponent,
    UserLocationRouting,
    UserLocationBuildDependency,
    UserLocationComponentDependency
  >,
  UserLocationBuildable
{

  override func build(
    with component: UserLocationComponent,
    _ payload: UserLocationBuildDependency
  ) -> UserLocationRouting {
    let viewController = UserLocationViewController()
    let interactor = UserLocationInteractor(
      presenter: viewController,
      initialState: component.initialState
    )
    interactor.listener = payload.listener

    return UserLocationRouter(
      interactor: interactor,
      viewController: viewController
    )
  }

  // MARK: - UserLocationBuildable

  func build(
    with dynamicBuildDependency: UserLocationBuildDependency,
    _ dynamicComponentDependency: UserLocationComponentDependency
  ) -> UserLocationRouting {
    return self.build(
      withDynamicBuildDependency: dynamicBuildDependency,
      dynamicComponentDependency: dynamicComponentDependency
    )
  }
}
