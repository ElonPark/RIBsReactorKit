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
  public final func build(
    with dynamicBuildDependency: DynamicBuildDependency
  ) -> Router {
    return build(
      withDynamicBuildDependency: dynamicBuildDependency,
      dynamicComponentDependency: Void()
    )
  }
}

// MARK: - DynamicComponentizedBuilder

extension ComponentizedBuilder where DynamicBuildDependency == Void {
  public final func build(
    with dynamicComponentDependency: DynamicComponentDependency
  ) -> Router {
    return build(
      withDynamicBuildDependency: Void(),
      dynamicComponentDependency: dynamicComponentDependency
    )
  }
}
