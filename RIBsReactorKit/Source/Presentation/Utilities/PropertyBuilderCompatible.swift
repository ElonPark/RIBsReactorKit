//
//  PropertyBuilderCompatible.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/05/22.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

// MARK: - PropertyBuilderCompatible

protocol PropertyBuilderCompatible {
  associatedtype Base
  var builder: PropertyBuilder<Base> { get }
}

extension PropertyBuilderCompatible {
  var builder: PropertyBuilder<Self> {
    PropertyBuilder(self)
  }
}

// MARK: - NSObject + PropertyBuilderCompatible

extension NSObject: PropertyBuilderCompatible {}

// MARK: - JSONEncoder + PropertyBuilderCompatible

extension JSONEncoder: PropertyBuilderCompatible {}

// MARK: - JSONDecoder + PropertyBuilderCompatible

extension JSONDecoder: PropertyBuilderCompatible {}
