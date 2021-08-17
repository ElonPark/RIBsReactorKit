//
//  UserInformationInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import ReactorKit
import RIBs
import RxSwift

// MARK: - UserInformationRouting

protocol UserInformationRouting: ViewableRouting {
  func attachUserLocationRIB(annotationMetadata: MapPointAnnotationMetadata)
  func detachUserLocationRIB()
}

// MARK: - UserInformationPresentable

protocol UserInformationPresentable: Presentable {
  var listener: UserInformationPresentableListener? { get set }
}

// MARK: - UserInformationListener

protocol UserInformationListener: AnyObject {
  func detachUserInformationRIB()
}

// MARK: - UserInformationInteractor

final class UserInformationInteractor:
  PresentableInteractor<UserInformationPresentable>,
  UserInformationInteractable,
  UserInformationPresentableListener,
  Reactor
{

  // MARK: - Reactor

  typealias Action = UserInformationPresentableAction
  typealias State = UserInformationPresentableState

  enum Mutation {
    case setUserInformationSections([UserInfoSectionModel])
    case attachUserLocationRIB(metadata: MapPointAnnotationMetadata)
    case detach
  }

  // MARK: - Properties

  weak var router: UserInformationRouting?
  weak var listener: UserInformationListener?

  let initialState: UserInformationPresentableState

  private let selectedUserModelStream: SelectedUserModelStream
  private let userInformationSectionListFactory: UserInfoSectionListFactory

  // MARK: - Initialization & Deinitialization

  init(
    initialState: UserInformationPresentableState,
    selectedUserModelStream: SelectedUserModelStream,
    userInformationSectionListFactory: UserInfoSectionListFactory,
    presenter: UserInformationPresentable
  ) {
    self.initialState = initialState
    self.selectedUserModelStream = selectedUserModelStream
    self.userInformationSectionListFactory = userInformationSectionListFactory
    super.init(presenter: presenter)
    presenter.listener = self
  }

  deinit {
    Log.verbose(type(of: self))
  }
}

// MARK: - Reactor

extension UserInformationInteractor {

  func sendAction(_ action: Action) {
    self.action.on(.next(action))
  }

  // MARK: - mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return setUserInformationSectionsMutation()

    case let .itemSelected(indexPath):
      return itemSelectedMutation(with: indexPath)

    case .detach:
      return .just(.detach)
    }
  }

  private func setUserInformationSectionsMutation() -> Observable<Mutation> {
    return selectedUserModelStream.userModel
      .withUnretained(self)
      .flatMap { this, userModel -> Observable<Mutation> in
        let sections = this.userInformationSectionListFactory.makeSections(by: userModel)
        return .just(.setUserInformationSections(sections))
      }
  }

  private func itemSelectedMutation(with indexPath: IndexPath) -> Observable<Mutation> {
    let section = currentState.userInformationSections[safe: indexPath.section]
    guard let item = section?.items[safe: indexPath.item] else { return .never() }
    Log.debug(item)

    switch item {
    case let .location(viewModel):
      return attachUserLocationRIBMutation(location: viewModel.location)

    default:
      return .never()
    }
  }

  private func attachUserLocationRIBMutation(location: Location) -> Observable<Mutation> {
    guard let coordinate = location.coordinates.locationCoordinate2D else { return .never() }

    let metadata = MapPointAnnotationMetadata(
      coordinate: coordinate,
      title: location.city,
      subtitle: location.street.name
    )
    return .just(.attachUserLocationRIB(metadata: metadata))
  }

  // MARK: - transform mutation

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .withUnretained(self)
      .flatMap { this, mutation -> Observable<Mutation> in
        switch mutation {
        case let .attachUserLocationRIB(metadata):
          return this.attachUserLocationRIBTransform(metadata: metadata)

        case .detach:
          return this.detachTransform()

        default:
          return .just(mutation)
        }
      }
  }

  private func attachUserLocationRIBTransform(metadata: MapPointAnnotationMetadata) -> Observable<Mutation> {
    router?.attachUserLocationRIB(annotationMetadata: metadata)
    return .empty()
  }

  private func detachTransform() -> Observable<Mutation> {
    listener?.detachUserInformationRIB()
    return .empty()
  }

  // MARK: - reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setUserInformationSections(sections):
      newState.userInformationSections = sections

    case .attachUserLocationRIB,
         .detach:
      Log.debug("Do Nothing when \(mutation)")
    }

    return newState
  }
}

// MARK: - UserLocationListener

extension UserInformationInteractor {
  func detachUserLocationRIB() {
    router?.detachUserLocationRIB()
  }
}
