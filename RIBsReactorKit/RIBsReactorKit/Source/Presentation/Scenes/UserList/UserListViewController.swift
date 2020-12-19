//
//  UserListViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import RxSwiftExt
import RxViewController
import SkeletonView

enum UserListPresentableAction {
  case loadData
  case refresh
  case loadMore(IndexPath)
  case itemSelected(IndexPath)
}

protocol UserListPresentableListener: class {
  typealias Action = UserListPresentableAction
  typealias State = UserListPresentableState
  
  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

final class UserListViewController:
  BaseViewController,
  PullToRefreshable,
  HasTableView,
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
  
  let tableView = UITableView().then {
    $0.register(UserListItemCell.self)
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = UI.userListCellEstimatedRowHeight
    $0.isSkeletonable = true
  }
  
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
  
  // MARK: - Binding

  private func bindUI() {
    bindRefreshControlEvent()
    bindDisplayDummyCellAnimation()
  }
  
  private func bindDisplayDummyCellAnimation() {
    tableView.rx.willDisplayCell
      .asDriver()
      .drive(onNext: { cell, indexPath in
        guard let userListCell = cell as? UserListItemCell,
          userListCell.isSkeletonActive,
          userListCell.viewModel == nil
          else {
            return
        }
        
        userListCell.alpha = 0
        UIView.animate(
          withDuration: 0.5,
          delay: 0.06 * Double(indexPath.row),
          animations: {
            userListCell.alpha = 1
        })
      })
      .disposed(by: disposeBag)
  }
  
  private func bind(listener: UserListPresentableListener?) {
    guard let listener = listener else { return }
  
    // Action
    bindActions(to: listener)
    
    // State
    bindState(from: listener)
  }
  
  // MARK: - Binding Action
  
  private func bindActions(to listener: UserListPresentableListener) {
    bindViewWillAppearAction(to: listener)
    bindRefreshControlAction(to: listener)
    bindLoadMoreAction(to: listener)
    bindItemSelectedAction(to: listener)
  }
  
  private func bindViewWillAppearAction(to listener: UserListPresentableListener) {
    rx.viewWillAppear
      .take(1)
      .map { _ in .loadData }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
  
  private func bindRefreshControlAction(to listener: UserListPresentableListener) {
    refreshEvent
      .map { .refresh }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
    
  private func bindLoadMoreAction(to listener: UserListPresentableListener) {
    tableView.rx.willDisplayCell
      .map { .loadMore($0.indexPath) }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
  
  private func bindItemSelectedAction(to listener: UserListPresentableListener) {
    tableView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Binding State
  
  private func bindState(from listener: UserListPresentableListener) {
    bindIsLoadingState(from: listener)
    bindIsRefreshState(from: listener)
    bindUserListSectionsState(from: listener)
  }
  
  private func bindIsLoadingState(from listener: UserListPresentableListener) {
    listener.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind { [weak self] isLoading in
        self?.tableViewSkeletonAnimation(by: isLoading)
    }
    .disposed(by: disposeBag)
  }
  
  private func bindIsRefreshState(from listener: UserListPresentableListener) {
    listener.state.map { $0.isRefresh }
      .distinctUntilChanged()
      .bind { [weak self] isRefresh in
        self?.tableViewSkeletonAnimation(by: isRefresh)
        
        guard !isRefresh else { return }
        self?.endRefreshing()
    }
    .disposed(by: disposeBag)
  }
  
  private func bindUserListSectionsState(from listener: UserListPresentableListener) {
    listener.state.map { $0.userListSections }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(tableView.rx.items(dataSource: dataSource()))
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private methods
  
  private func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: "List",
      image: R.image.listTab(),
      selectedImage: nil
    )
  }
  
  private func dataSource() -> UserListDataSource {
    return UserListDataSource(
      configureCell: { _, tableView, indexPath, sectionItem in
        switch sectionItem {
        case .user(let viewModel):
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          cell.viewModel = viewModel
          return cell
          
        case .dummy:
          let cell = tableView.dequeue(UserListItemCell.self, indexPath: indexPath)
          return cell
        }
    })
  }
  
  private func tableViewSkeletonAnimation(by isLoading: Bool) {
    if isLoading {
      tableView.showAnimatedGradientSkeleton()
    } else {
      tableView.hideSkeleton(transition: .crossDissolve(0.25))
      // To fix UILabel text when it is not visible after tableView.hideSkeleton.
      tableView.reloadData()
    }
  }
}

// MARK: - Layout
extension UserListViewController {
  private func setupUI() {
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
extension UserListViewController {
  fileprivate func bindDummyItems() {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
    guard let randomUser = try? decoder.decode(RandomUser.self, from: RandomUserFixture.data) else { return }
    let userModelTranslator = UserModelTranslatorImpl()
    
    let dummySectionItems = userModelTranslator.translateToUserModel(by: randomUser.results)
      .map { UserListItemViewModel(userModel: $0) }
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
        let viewController = UserListViewController().then {
          $0.bindDummyItems()
        }
        return UINavigationController(rootViewController: viewController)
      }
      .previewDevice(PreviewDevice(rawValue: deviceName))
      .previewDisplayName(deviceName)
    }
  }
}
#endif
