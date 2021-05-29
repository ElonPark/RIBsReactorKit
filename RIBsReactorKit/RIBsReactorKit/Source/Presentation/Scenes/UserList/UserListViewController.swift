//
//  UserListViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import ReactorKit
import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import SkeletonView

// MARK: - UserListPresentableAction

enum UserListPresentableAction {
  case loadData
  case refresh
  case loadMore(IndexPath)
  case itemSelected(IndexPath)
}

// MARK: - UserListPresentableListener

protocol UserListPresentableListener: AnyObject {
  typealias Action = UserListPresentableAction
  typealias State = UserListPresentableState

  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - UserListViewController

final class UserListViewController:
  BaseViewController,
  HasTableView,
  PullToRefreshable,
  UserListPresentable,
  UserListViewControllable
{

  // MARK: - Constants

  private enum UI {
    static let userListCellEstimatedRowHeight: CGFloat = 100
  }

  typealias UserListDataSource = RxTableViewSectionedReloadDataSource<UserListSectionModel>

  // MARK: - Properties

  weak var listener: UserListPresentableListener?

  let refreshEvent = PublishRelay<Void>()

  // MARK: - UI Components

  let refreshControl = UIRefreshControl()

  let tableView = UITableView().builder
    .rowHeight(UITableView.automaticDimension)
    .estimatedRowHeight(UI.userListCellEstimatedRowHeight)
    .isSkeletonable(true)
    .reinforce {
      $0.register(UserListItemCell.self)
      $0.showAnimatedGradientSkeleton()
    }
    .build()

  // MARK: - Initialization & Deinitialization

  override init() {
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

  func dataSource() -> UserListDataSource {
    UserListDataSource(
      configureCell: { _, tableView, indexPath, sectionItem in
        switch sectionItem {
        case let .user(viewModel):
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          cell.configure(by: viewModel)
          return cell

        case .dummy:
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          return cell
        }
      }
    )
  }
}

// MARK: - Binding

private extension UserListViewController {
  func bindUI() {
    bindRefreshControlEvent()
    bindDisplayDummyCellAnimation()
  }

  func bindDisplayDummyCellAnimation() {
    tableView.rx.willDisplayCell
      .asDriver()
      .drive(onNext: { cell, indexPath in
        guard let userListCell = cell as? UserListItemCell,
              userListCell.isSkeletonActive && userListCell.viewModel == nil else { return }

        userListCell.alpha = 0
        UIView.animate(
          withDuration: 0.5,
          delay: 0.06 * Double(indexPath.row),
          animations: {
            userListCell.alpha = 1
          }
        )
      })
      .disposed(by: disposeBag)
  }

  func bind(listener: UserListPresentableListener?) {
    guard let listener = listener else { return }
    bindActions(to: listener)
    bindState(from: listener)
  }
}

// MARK: - Binding Action

private extension UserListViewController {
  func bindActions(to listener: UserListPresentableListener) {
    bindViewWillAppearAction(to: listener)
    bindRefreshControlAction(to: listener)
    bindLoadMoreAction(to: listener)
    bindItemSelectedAction(to: listener)
  }

  func bindViewWillAppearAction(to listener: UserListPresentableListener) {
    rx.viewWillAppear
      .take(1)
      .map { _ in .loadData }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  func bindRefreshControlAction(to listener: UserListPresentableListener) {
    refreshEvent
      .map { .refresh }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  func bindLoadMoreAction(to listener: UserListPresentableListener) {
    tableView.rx.willDisplayCell
      .map { .loadMore($0.indexPath) }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  func bindItemSelectedAction(to listener: UserListPresentableListener) {
    tableView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding State

private extension UserListViewController {
  func bindState(from listener: UserListPresentableListener) {
    bindIsLoadingState(from: listener)
    bindIsRefreshState(from: listener)
    bindUserListSectionsState(from: listener)
  }

  func bindIsLoadingState(from listener: UserListPresentableListener) {
    listener.state.map(\.isLoading)
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { this, isLoading in
        this.tableViewSkeletonAnimation(by: isLoading)
      }
      .disposed(by: disposeBag)
  }

  func bindIsRefreshState(from listener: UserListPresentableListener) {
    listener.state.map(\.isRefresh)
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { this, isRefresh in
        this.tableViewSkeletonAnimation(by: isRefresh)

        guard !isRefresh else { return }
        this.endRefreshing()
      }
      .disposed(by: disposeBag)
  }

  func tableViewSkeletonAnimation(by isLoading: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let this = self else { return }
      if isLoading {
        this.tableView.showAnimatedGradientSkeleton()
      } else {
        this.tableView.hideSkeleton(transition: .crossDissolve(0.25))
      }
    }
  }

  func bindUserListSectionsState(from listener: UserListPresentableListener) {
    listener.state.map(\.userListSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(tableView.rx.items(dataSource: dataSource()))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

extension UserListViewController {
  private func setupUI() {
    navigationItem.title = Strings.UserList.title
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
        .drive(tableView.rx.items(dataSource: dataSource()))
        .disposed(by: disposeBag)
    }
  }

  import SwiftUI

  private let deviceNames: [String] = [
    "iPhone SE",
    "iPhone 11 Pro Max"
  ]

  @available(iOS 13.0, *)
  struct UserListViewControllerPreview: PreviewProvider {

    static var previews: some SwiftUI.View {
      ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
          let viewController = UserListViewController().builder
            .reinforce { $0.bindDummyItems() }
            .build()

          return UINavigationController(rootViewController: viewController)
        }
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
      }
    }
  }
#endif
