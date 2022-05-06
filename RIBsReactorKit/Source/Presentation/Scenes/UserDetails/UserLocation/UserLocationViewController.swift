//
//  UserLocationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import MapKit
import UIKit

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

  func sendAction(_ action: Action)
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

  private let actionRelay = PublishRelay<UserLocationPresentableListener.Action>()

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
    bindActionRelay()
    bindAction()
    bindState(from: listener)
  }

  func bindActionRelay() {
    actionRelay.asObservable()
      .bind(with: self) { this, action in
        this.listener?.sendAction(action)
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Binding State

  func bindAction() {
    bindDetachAction()
  }

  func bindDetachAction() {
    detachAction
      .map { .detachAction }
      .bind(to: actionRelay)
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
    view.backgroundColor = Asset.Colors.backgroundColor.color
    addHeaderViewIfNeeded(to: view)
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
