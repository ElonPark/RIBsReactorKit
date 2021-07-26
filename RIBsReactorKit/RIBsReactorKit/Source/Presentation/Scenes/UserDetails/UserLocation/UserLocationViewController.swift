//
//  UserLocationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import MapKit
import UIKit

import ReactorKit
import RIBs
import RxCocoa
import RxSwift

// MARK: - UserLocationPresentableAction

enum UserLocationPresentableAction {
  case detachAction
}

// MARK: - UserLocationPresentableListener

protocol UserLocationPresentableListener: AnyObject {
  typealias Action = UserLocationPresentableAction
  typealias State = UserLocationPresentableState

  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
}

// MARK: - UserLocationViewController

final class UserLocationViewController:
  BaseViewController,
  UserLocationPresentable,
  UserLocationViewControllable,
  MapRegionSettable,
  MapAnnotationAddable,
  HasCloseButtonHeaderView,
  CloseButtonBindable
{

  // MARK: - Properties

  weak var listener: UserLocationPresentableListener?

  // MARK: - UI Components

  let headerView = CloseButtonHeaderView()

  private let mapView = MKMapView()

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindUI()
    bind(to: listener)
  }
}

// MARK: - Bind UI

private extension UserLocationViewController {
  func bindUI() {
    guard needHeaderView else { return }
    bindCloseButtonTapAction()
  }
}

// MARK: - Bind listener

private extension UserLocationViewController {
  func bind(to listener: UserLocationPresentableListener?) {
    guard let listener = listener else { return }
    bindAction(to: listener)
    bindState(from: listener)
  }

  // MARK: - Binding State

  func bindAction(to listener: UserLocationPresentableListener) {
    bindDetachAction(to: listener)
  }

  func bindDetachAction(to listener: UserLocationPresentableListener) {
    detachAction
      .map { .detachAction }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  // MARK: - Binding State

  func bindState(from listener: UserLocationPresentableListener) {
    bindAnnotationMetadata(from: listener)
  }

  private func bindAnnotationMetadata(from listener: UserLocationPresentableListener) {
    listener.state.map(\.annotationMetadata)
      .distinctUntilChanged()
      .bind(with: self) { this, metadata in
        this.setMapView(metadata: metadata)
      }
      .disposed(by: disposeBag)
  }

  private func setMapView(metadata: MapPointAnnotationMetadata) {
    let coordinate = CLLocationCoordinate2D(
      latitude: metadata.coordinate.latitude,
      longitude: metadata.coordinate.longitude
    )
    setRegion(to: mapView, center: coordinate)
    addMapAnnotation(to: mapView, coordinate: coordinate, title: metadata.title, subtitle: metadata.subtitle)
  }
}

// MARK: - SetupUI

private extension UserLocationViewController {
  func setupUI() {
    if needHeaderView {
      view.addSubview(headerView)
    }
    view.addSubview(mapView)

    layout()
  }

  func layout() {
    makeHeaderViewConstraintsIfNeeded()
    makeMapViewConstraints()
  }

  func makeMapViewConstraints() {
    mapView.snp.makeConstraints {
      if needHeaderView {
        $0.top.equalTo(headerView.snp.bottom)
        $0.leading.trailing.bottom.equalToSuperview()
      } else {
        $0.edges.equalToSuperview()
      }
    }
  }
}
