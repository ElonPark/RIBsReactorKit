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

// MARK: - UserLocationComponent

final class UserLocationComponent:
  NeedleFoundation.Component<UserLocationDependency>,
  UserLocationInteractorDependency
{

  var initialState: UserLocationPresentableState {
    UserLocationPresentableState(annotationMetadata: annotationMetadata)
  }

  private let annotationMetadata: MapPointAnnotationMetadata

  init(parent: Scope, annotationMetadata: MapPointAnnotationMetadata) {
    self.annotationMetadata = annotationMetadata
    super.init(parent: parent)
  }
}

// MARK: - UserLocationBuildable

protocol UserLocationBuildable: Buildable {
  func build(
    withListener listener: UserLocationListener,
    annotationMetadata: MapPointAnnotationMetadata
  ) -> UserLocationRouting
}

// MARK: - UserLocationBuilder

final class UserLocationBuilder:
  ComponentizedBuilder<UserLocationComponent, UserLocationRouting, UserLocationListener, MapPointAnnotationMetadata>,
  UserLocationBuildable
{

  override func build(with component: UserLocationComponent, _ listener: UserLocationListener) -> UserLocationRouting {
    let viewController = UserLocationViewController()
    let interactor = UserLocationInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener

    return UserLocationRouter(interactor: interactor, viewController: viewController)
  }

  // MARK: - UserLocationBuildable

  func build(
    withListener listener: UserLocationListener,
    annotationMetadata: MapPointAnnotationMetadata
  ) -> UserLocationRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: annotationMetadata)
  }
}
