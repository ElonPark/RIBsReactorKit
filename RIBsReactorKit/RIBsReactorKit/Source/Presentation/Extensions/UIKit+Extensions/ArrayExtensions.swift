//
//  ArrayExtensions.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/08.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
