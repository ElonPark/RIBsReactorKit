//
//  UserCollectionPresenter.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxRelay
import RxSwift

// MARK: - UserCollectionAction

enum UserCollectionAction {
  case loadData
  case refresh
  case loadMore(index: Int)
  case itemSelected(index: Int)
}

// MARK: - UserCollectionPresentableListener

protocol UserCollectionPresentableListener: AnyObject {
  typealias Action = UserCollectionAction
  typealias State = UserCollectionState

  func sendAction(_ action: Action)
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - UserCollectionPresenter

final class UserCollectionPresenter:
  Presenter<UserCollectionViewControllable>,
  UserCollectionPresentable,
  UserCollectionViewControllableListener,
  HasViewModel,
  HasDisposeBag
{

  // MARK: - Properties

  weak var listener: UserCollectionPresentableListener?

  var viewModel: Observable<ViewModel> {
    guard let listener = listener else { return .never() }
    return listener.state
      .withUnretained(self)
      .map(transform())
  }

  var disposeBag = DisposeBag()

  // MARK: - Initialization & Deinitialization

  override init(viewController: UserCollectionViewControllable) {
    super.init(viewController: viewController)
    viewController.listener = self
  }

  func sendAction(_ action: Action) {
    guard let listener = listener else { return }

    switch action {
    case .loadData:
      listener.sendAction(.loadData)

    case .refresh:
      listener.sendAction(.refresh)

    case let .itemSelected(indexPath):
      listener.sendAction(.itemSelected(index: indexPath.item))

    case let .loadMore(indexPath):
      listener.sendAction(.loadMore(index: indexPath.item))
    }
  }
}

// MARK: - Data Model to ViewModel

private extension UserCollectionPresenter {
  func transform() -> (UserCollectionPresenter, UserCollectionPresentableListener.State) -> ViewModel {
    return { this, state in
      ViewModel(
        isLoading: state.isLoading,
        isRefresh: state.isRefresh,
        userCollectionSections: this.makeSectionModel(byUserModels: state.userModels)
      )
    }
  }

  func makeSectionModel(byUserModels userModels: [UserModel]) -> [UserCollectionSectionModel] {
    let sectionItem = userModels
      .map(UserProfileViewModel.init)
      .map(UserCollectionSectionItem.user)

    return [UserCollectionSectionModel.randomUser(sectionItem)]
  }
}
