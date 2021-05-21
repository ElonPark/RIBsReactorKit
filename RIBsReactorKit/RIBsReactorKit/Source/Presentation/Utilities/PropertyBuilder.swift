//
//  PropertyBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/05/22.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

// MARK: - PropertyBuilder

@dynamicMemberLookup
struct PropertyBuilder<Base> {

  private let base: Base

  init(_ base: Base) {
    self.base = base
  }

  subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> PropertyBuilder<Base> {
    return { [base] value in
      var object = base
      object[keyPath: keyPath] = value
      return PropertyBuilder(object)
    }
  }

  subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> Base {
    return { [base] value in
      var object = base
      object[keyPath: keyPath] = value
      return object
    }
  }

  func set<Value>(_ keyPath: WritableKeyPath<Base, Value>, to value: Value) -> PropertyBuilder<Base> {
    var object = base
    object[keyPath: keyPath] = value
    return PropertyBuilder(object)
  }

  func build() -> Base {
    return base
  }
}

extension PropertyBuilder {
  func reinforce(_ handler: (inout Base) -> Void) -> PropertyBuilder<Base> {
    PropertyBuilder(reinforce(handler))
  }

  func reinforce(_ handler: (inout Base) -> Void) -> Base {
    var object = base
    handler(&object)
    return object
  }
}
