//
//  UserCollectionViewController.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxCocoa
import RxDataSources
import RxSwift

// MARK: - UserCollectionViewControllableListener

protocol UserCollectionViewControllableListener: AnyObject, HasLoadingStream, HasRefreshStream {
  typealias Action = UserListPresentableAction
  typealias ViewModel = UserCollectionViewModel

  func sendAction(_ action: Action)
  var viewModel: Observable<ViewModel> { get }
}

// MARK: - UserCollectionViewController

final class UserCollectionViewController:
  BaseViewController,
  UserCollectionViewControllable,
  HasCollectionView,
  PullToRefreshable,
  SkeletonControllable,
  LoadingStreamBindable,
  RefreshStreamBindable
{

  // MARK: - Constants

  private enum UI {
    static let cellMargin: CGFloat = 5
    static let profileCellHeight: CGFloat = 250
  }

  typealias UserCollectionDataSource = RxCollectionViewSectionedReloadDataSource<UserCollectionSectionModel>

  // MARK: - Properties

  weak var listener: UserCollectionViewControllableListener?

  let refreshEvent = PublishRelay<Void>()

  private let actionRelay = PublishRelay<UserCollectionViewControllableListener.Action>()

  // MARK: - UI Components

  let refreshControl = UIRefreshControl()

  private let flowLayout = UICollectionViewFlowLayout().builder
    .scrollDirection(.vertical)
    .build()

  private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).builder
    .backgroundColor(Asset.Colors.backgroundColor.color)
    .with {
      $0.register(UserProfileCell.self)
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

private extension UserCollectionViewController {
  func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: Strings.TabBarTitle.collection,
      image: Asset.Images.TabBarIcons.collectionTab.image,
      selectedImage: nil
    )
  }

  func dataSource() -> UserCollectionDataSource {
    return UserCollectionDataSource(
      configureCell: { _, collectionView, indexPath, section in
        switch section {
        case let .user(viewModel):
          let cell = collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
          cell.configure(by: viewModel)
          return cell

        case .dummy:
          let cell = collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
          cell.showAnimatedGradientSkeleton()
          return cell
        }
      }
    )
  }
}

// MARK: - Bind UI

private extension UserCollectionViewController {
  func bindUI() {
    bindCollectionViewSetDelegate()
    bindRefreshControlEvent()
  }

  func bindCollectionViewSetDelegate() {
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

// MARK: - Bind listener

private extension UserCollectionViewController {
  func bind(listener: UserCollectionViewControllableListener?) {
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

private extension UserCollectionViewController {
  func bindActions() {
    bindViewWillAppearAction()
    bindRefreshControlAction()
    bindLoadMoreAction()
    bindItemSelectedAction()
  }

  func bindViewWillAppearAction() {
    rx.viewWillAppear
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
    collectionView.rx.willDisplayCell
      .map { .loadMore($0.at) }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }

  func bindItemSelectedAction() {
    collectionView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding State

private extension UserCollectionViewController {
  func bindState(from listener: UserCollectionViewControllableListener) {
    bindLoadingStream(from: listener)
    bindRefreshStream(from: listener)
    bindUserListSectionsState(from: listener)
  }

  func bindUserListSectionsState(from listener: UserCollectionViewControllableListener) {
    listener.viewModel.map(\.userCollectionSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSource()))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

private extension UserCollectionViewController {
  func setupUI() {
    navigationItem.title = Strings.UserCollection.title
    view.addSubview(collectionView)

    setRefreshControl()
    layout()
  }

  func layout() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let margin = UI.cellMargin * 2
    var width = (collectionView.frame.width - margin) / 2
    if traitCollection.horizontalSizeClass == .regular {
      width = (collectionView.readableContentGuide.layoutFrame.width - margin) / 2
    }

    width = floor(width)
    return CGSize(width: width, height: UI.profileCellHeight)
  }
}

#if canImport(SwiftUI) && DEBUG
  import SwiftUI

  private let deviceNames: [String] = [
    "iPhone SE",
    "iPhone 11 Pro Max"
  ]

  @available(iOS 13.0, *)
  struct UserCollectionControllerPreview: PreviewProvider {
    static var previews: some View {
      ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
          let viewController = UserCollectionViewController()
          return UINavigationController(rootViewController: viewController)
        }
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
      }
    }
  }
#endif
