//
//  MapPointAnnotationMetadata.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import CoreLocation
import Foundation

struct MapPointAnnotationMetadata: Equatable {
  let coordinate: Coordinate2D
  let title: String
  let subtitle: String
}
