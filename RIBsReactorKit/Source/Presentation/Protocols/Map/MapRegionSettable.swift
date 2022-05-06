//
//  MapRegionSettable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation
import MapKit

// MARK: - MapRegionSettable

protocol MapRegionSettable {
  func setRegion(to mapView: MKMapView, center: CLLocationCoordinate2D)
}

extension MapRegionSettable {
  func setRegion(to mapView: MKMapView, center: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: center, span: span)
    mapView.setRegion(region, animated: true)
  }
}
