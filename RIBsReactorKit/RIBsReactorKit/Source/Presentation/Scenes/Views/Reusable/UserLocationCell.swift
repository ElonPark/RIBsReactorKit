//
//  UserLocationCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/04/19.
//  Copyright © 2021 Elon. All rights reserved.
//

import MapKit
import UIKit

// MARK: - UserLocationCell

final class UserLocationCell:
  BaseCollectionViewCell,
  HasViewModel,
  HasConfigure,
  SkeletonAnimatable
{

  // MARK: - Properties

  private(set) var viewModel: UserLocationViewModel?

  // MARK: - UI Components

  private let mapView = MKMapView().builder
    .isScrollEnabled(false)
    .isRotateEnabled(false)
    .build()

  private(set) lazy var views: [UIView] = [mapView]

  // MARK: - Inheritance

  override func initialize() {
    super.initialize()
    setupUI()
  }

  override func setupConstraints() {
    super.setupConstraints()
    layout()
  }

  // MARK: - Internal methods

  func configure(by viewModel: UserLocationViewModel) {
    self.viewModel = viewModel
    hideSkeletonAnimation()

    guard let coordinate = viewModel.location.coordinates.locationCoordinate2D else { return }
    setMapViewRegion(center: coordinate)
    setMapViewAnnotation(
      coordinate: coordinate,
      title: viewModel.location.city,
      subtitle: viewModel.location.street.name
    )
  }

  // MARK: - Private methods

  private func setMapViewRegion(center: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: center, span: span)
    mapView.setRegion(region, animated: true)
  }

  private func setMapViewAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
    let point = MKPointAnnotation().builder
      .coordinate(coordinate)
      .title(title)
      .subtitle(subtitle)
      .build()

    mapView.addAnnotation(point)
  }
}

// MARK: - Layout

extension UserLocationCell {
  private func setupUI() {
    isSkeletonable = true
    views.forEach { self.contentView.addSubview($0) }

    showSkeletonAnimation()
  }

  private func layout() {
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
