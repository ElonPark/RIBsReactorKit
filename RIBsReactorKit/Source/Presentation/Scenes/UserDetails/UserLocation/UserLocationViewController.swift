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
    bind(to: self.listener)
  }
}

// MARK: - Bind UI

extension UserLocationViewController {
  private func bindUI() {
    guard needHeaderView else { return }
    bindCloseButtonTapAction()
  }
}

// MARK: - Bind listener

extension UserLocationViewController {
  private func bind(to listener: UserLocationPresentableListener?) {
    guard let listener = listener else { return }
    self.bindActionRelay()
    self.bindAction()
    self.bindState(from: listener)
  }

  private func bindActionRelay() {
    self.actionRelay.asObservable()
      .bind(with: self) { this, action in
        this.listener?.sendAction(action)
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Binding State

  private func bindAction() {
    self.bindDetachAction()
  }

  private func bindDetachAction() {
    detachAction
      .map { .detachAction }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  // MARK: - Binding State

  private func bindState(from listener: UserLocationPresentableListener) {
    self.bindAnnotationMetadata(from: listener)
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
    setRegion(to: self.mapView, center: coordinate)
    addMapAnnotation(to: self.mapView, coordinate: coordinate, title: metadata.title, subtitle: metadata.subtitle)
  }
}

// MARK: - SetupUI

extension UserLocationViewController {
  private func setupUI() {
    view.backgroundColor = Asset.Colors.backgroundColor.color
    addHeaderViewIfNeeded(to: view)
    view.addSubview(self.mapView)

    self.layout()
  }

  private func layout() {
    makeHeaderViewConstraintsIfNeeded()
    self.makeMapViewConstraints()
  }

  private func makeMapViewConstraints() {
    self.mapView.snp.makeConstraints {
      if needHeaderView {
        $0.top.equalTo(headerView.snp.bottom)
        $0.leading.trailing.bottom.equalToSuperview()
      } else {
        $0.edges.equalToSuperview()
      }
    }
  }
}
