//
//  MapAnnotationAddable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation
import MapKit

// MARK: - MapAnnotationAddable

protocol MapAnnotationAddable {
  func addMapAnnotation(to mapView: MKMapView, coordinate: CLLocationCoordinate2D, title: String, subtitle: String)
}

extension MapAnnotationAddable {
  func addMapAnnotation(to mapView: MKMapView, coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    let point = MKPointAnnotation().builder
      .coordinate(coordinate)
      .title(title)
      .subtitle(subtitle)
      .build()

    mapView.addAnnotation(point)
  }
}
