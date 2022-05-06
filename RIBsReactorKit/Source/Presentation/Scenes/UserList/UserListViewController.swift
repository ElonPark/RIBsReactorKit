//
//  UserListViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController

// MARK: - UserListPresentableAction

enum UserListPresentableAction {
  case loadData
  case refresh
  case loadMore(IndexPath)
  case prefetchItems([IndexPath])
  case itemSelected(IndexPath)
}

// MARK: - UserListPresentableListener

protocol UserListPresentableListener: AnyObject, HasLoadingStream, HasRefreshStream {
  typealias Action = UserListPresentableAction
  typealias State = UserListPresentableState

  func sendAction(_ action: Action)
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - UserListViewController

final class UserListViewController:
  BaseViewController,
  UserListPresentable,
  UserListViewControllable,
  HasTableView,
  PullToRefreshable,
  SkeletonControllable,
  LoadingStreamBindable,
  RefreshStreamBindable
{

  // MARK: - Constants

  private enum UI {
    static let userListCellEstimatedRowHeight: CGFloat = 100
  }

  typealias UserListDataSource = RxTableViewSectionedReloadDataSource<UserListSectionModel>

  // MARK: - Properties

  weak var listener: UserListPresentableListener?

  let refreshEvent = PublishRelay<Void>()

  private let actionRelay = PublishRelay<UserListPresentableListener.Action>()

  private let dataSource: UserListDataSource

  // MARK: - UI Components

  let refreshControl = UIRefreshControl()

  let tableView = UITableView().builder
    .rowHeight(UITableView.automaticDimension)
    .estimatedRowHeight(UI.userListCellEstimatedRowHeight)
    .isSkeletonable(true)
    .with {
      $0.register(UserListItemCell.self)
      $0.register(DummyUserListItemCell.self)
    }
    .build()

  // MARK: - Initialization & Deinitialization

  override init() {
    self.dataSource = Self.dataSource()
    super.init()
    setTabBarItem()
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindUI()
    bind(listener: self.listener)
  }
}

// MARK: - Private methods

extension UserListViewController {
  private func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: Strings.TabBarTitle.list,
      image: Asset.Images.TabBarIcons.listTab.image,
      selectedImage: nil
    )
  }

  fileprivate static func dataSource() -> UserListDataSource {
    return UserListDataSource(
      configureCell: { _, tableView, indexPath, sectionItem in
        switch sectionItem {
        case let .user(viewModel):
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          cell.configure(by: viewModel)
          return cell

        case .dummy:
          let cell = tableView.dequeue(DummyUserListItemCell.self, indexPath: indexPath)
          return cell
        }
      }
    )
  }
}

// MARK: - Bind UI

extension UserListViewController {
  private func bindUI() {
    bindRefreshControlEvent()
  }
}

// MARK: - Bind listener

extension UserListViewController {
  private func bind(listener: UserListPresentableListener?) {
    guard let listener = listener else { return }
    self.bindActionRelay()
    bindActions()
    bindState(from: listener)
  }

  private func bindActionRelay() {
    self.actionRelay.asObservable()
      .bind(with: self) { this, action in
        this.listener?.sendAction(action)
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding Action

extension UserListViewController {
  private func bindActions() {
    self.bindViewWillAppearAction()
    self.bindRefreshControlAction()
    self.bindLoadMoreAction()
    self.bindPrefetchItemsAction()
    self.bindItemSelectedAction()
  }

  private func bindViewWillAppearAction() {
    rx.viewWillAppear
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { _ in .loadData }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindRefreshControlAction() {
    self.refreshEvent
      .map { .refresh }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindLoadMoreAction() {
    self.tableView.rx.willDisplayCell
      .map { .loadMore($0.indexPath) }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindPrefetchItemsAction() {
    self.tableView.rx.prefetchRows
      .map { .prefetchItems($0) }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindItemSelectedAction() {
    self.tableView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding State

extension UserListViewController {
  private func bindState(from listener: UserListPresentableListener) {
    bindLoadingStream(from: listener)
    bindRefreshStream(from: listener)
    self.bindUserListSectionsState(from: listener)
  }

  private func bindUserListSectionsState(from listener: UserListPresentableListener) {
    listener.state.map(\.userListSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

extension UserListViewController {
  private func setupUI() {
    navigationItem.title = Strings.UserList.title
    view.addSubview(self.tableView)

    setRefreshControl()
    self.layout()
  }

  private func layout() {
    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  extension UserListViewController {
    fileprivate func bindDummyItems() {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
      guard let randomUser = try? decoder.decode(RandomUser.self, from: RandomUserFixture.data) else { return }
      let userModelTranslator = UserModelTranslatorImpl()

      let dummySectionItems = userModelTranslator.translateToUserModel(by: randomUser.results)
        .map(UserListItemViewModel.init)
        .map(UserListSectionItem.user)

      Observable.just([.randomUser(dummySectionItems)])
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: [])
        .drive(self.tableView.rx.items(dataSource: self.dataSource))
        .disposed(by: disposeBag)
    }
  }

  import SwiftUI

  private let deviceNames: [String] = [
    "iPhone SE",
    "iPhone 11 Pro Max"
  ]

  struct UserListViewControllerPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
          let viewController = UserListViewController().builder
            .with { $0.bindDummyItems() }
            .build()

          return UINavigationController(rootViewController: viewController)
        }
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
      }
    }
  }
#endif
