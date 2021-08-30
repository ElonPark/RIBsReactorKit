//
//  UserListViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import Kingfisher
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
    bind(listener: listener)
  }
}

// MARK: - Private methods

private extension UserListViewController {
  func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: Strings.TabBarTitle.list,
      image: Asset.Images.TabBarIcons.listTab.image,
      selectedImage: nil
    )
  }

  static func dataSource() -> UserListDataSource {
    return UserListDataSource(
      configureCell: { _, tableView, indexPath, sectionItem in
        switch sectionItem {
        case let .user(viewModel):
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          cell.configure(by: viewModel)
          return cell

        case .dummy:
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          cell.showAnimatedGradientSkeleton()
          return cell
        }
      }
    )
  }

  func prefetchImages(byIndexPaths indexPaths: [IndexPath]) {
    let urls = indexPaths
      .compactMap { dataSource.sectionModels[safe: $0.section]?.items[safe: $0.row] }
      .compactMap { item -> URL? in
        guard case let .user(viewModel) = item else { return nil }
        return viewModel.profileImageURL
      }

    ImagePrefetcher(urls: urls).start()
  }
}

// MARK: - Bind UI

private extension UserListViewController {
  func bindUI() {
    bindRefreshControlEvent()
  }
}

// MARK: - Bind listener

private extension UserListViewController {
  func bind(listener: UserListPresentableListener?) {
    guard let listener = listener else { return }
    bindActionRelay()
    bindActions()
    bindState(from: listener)
  }

  func bindActionRelay() {
    actionRelay.asObservable()
      .bind(with: self) { this, action in
        this.listener?.sendAction(action)
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding Action

private extension UserListViewController {
  func bindActions() {
    bindViewWillAppearAction()
    bindRefreshControlAction()
    bindLoadMoreAction()
    bindItemSelectedAction()
  }

  func bindViewWillAppearAction() {
    rx.viewWillAppear
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { _ in .loadData }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }

  func bindRefreshControlAction() {
    refreshEvent
      .map { .refresh }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }

  func bindLoadMoreAction() {
    tableView.rx.willDisplayCell
      .map { .loadMore($0.indexPath) }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }

  func bindItemSelectedAction() {
    tableView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding State

private extension UserListViewController {
  func bindState(from listener: UserListPresentableListener) {
    bindLoadingStream(from: listener)
    bindRefreshStream(from: listener)
    bindUserListSectionsState(from: listener)
  }

  func bindUserListSectionsState(from listener: UserListPresentableListener) {
    listener.state.map(\.userListSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

extension UserListViewController {
  private func setupUI() {
    navigationItem.title = Strings.UserList.title
    tableView.prefetchDataSource = self
    view.addSubview(tableView)

    setRefreshControl()
    layout()
  }

  private func layout() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - UITableViewDataSourcePrefetching

extension UserListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    prefetchImages(byIndexPaths: indexPaths)
  }
}

#if canImport(SwiftUI) && DEBUG
  fileprivate extension UserListViewController {
    func bindDummyItems() {
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
        .drive(tableView.rx.items(dataSource: dataSource))
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
