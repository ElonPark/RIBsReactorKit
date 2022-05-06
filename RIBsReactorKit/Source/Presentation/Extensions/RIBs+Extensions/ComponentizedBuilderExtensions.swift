//
//  ComponentizedBuilderExtensions.swift
//  RIBsReactorKit
//
//  Created by elon on 2022/05/01.
//  Copyright © 2022 Elon. All rights reserved.
//

import RIBs

// MARK: - DynamicBuildComponentizedBuilder

extension ComponentizedBuilder where DynamicComponentDependency == Void {
  final func build(
    with dynamicBuildDependency: DynamicBuildDependency
  ) -> Router {
    return self.build(
      withDynamicBuildDependency: dynamicBuildDependency,
      dynamicComponentDependency: Void()
    )
  }
}

// MARK: - DynamicComponentizedBuilder

extension ComponentizedBuilder where DynamicBuildDependency == Void {
  final func build(
    with dynamicComponentDependency: DynamicComponentDependency
  ) -> Router {
    return self.build(
      withDynamicBuildDependency: Void(),
      dynamicComponentDependency: dynamicComponentDependency
    )
  }
}
