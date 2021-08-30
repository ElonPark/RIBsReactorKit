//
//  UserInformationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxCocoa
import RxDataSources
import RxSwift

// MARK: - UserInformationPresentableAction

enum UserInformationPresentableAction {
  case viewWillAppear
  case itemSelected(IndexPath)
  case detach
}

// MARK: - UserInformationPresentableListener

protocol UserInformationPresentableListener: AnyObject {
  typealias Action = UserInformationPresentableAction
  typealias State = UserInformationPresentableState

  func sendAction(_ action: Action)
  var state: Observable<State> { get }
}

// MARK: - UserInformationViewController

final class UserInformationViewController:
  BaseViewController,
  UserInformationPresentable,
  UserInformationViewControllable,
  HasCollectionView,
  HasCloseButtonHeaderView,
  CloseButtonBindable
{

  // MARK: - Constants

  private enum UI {
    static let headerHeight: CGFloat = 50
    static let footerHeight: CGFloat = 10
    static let profileCellHeight: CGFloat = 250
    static let detailCellHeight: CGFloat = 65
    static let locationCellHeight: CGFloat = 250
  }

  typealias UserInformationDataSource = RxCollectionViewSectionedReloadDataSource<UserInfoSectionModel>

  // MARK: - Properties

  weak var listener: UserInformationPresentableListener?

  private let actionRelay = PublishRelay<UserInformationPresentableListener.Action>()

  // MARK: - UI Components

  let headerView = CloseButtonHeaderView()

  private let flowLayout = UICollectionViewFlowLayout().builder
    .scrollDirection(.vertical)
    .build()

  private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).builder
    .backgroundColor(Asset.Colors.backgroundColor.color)
    .with {
      $0.register(UserProfileCell.self)
      $0.register(UserDetailInfoCell.self)
      $0.register(UserLocationCell.self)
      $0.register(UserInfoHeaderView.self)
      $0.register(UserInfoFooterView.self)
      $0.register(EmptyReusableView.self)
    }
    .build()

  private let dataSource: UserInformationDataSource

  // MARK: - Initialization & Deinitialization

  override init() {
    self.dataSource = Self.dataSourceFactory()
    super.init()
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindUI()
    bind(listener: listener)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNavigationBarStyle()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    resetNavigationBarStyle()
  }
}

// MARK: - Private methods

private extension UserInformationViewController {
  static func dataSourceFactory() -> UserInformationDataSource {
    return .init(configureCell: { _, collectionView, indexPath, section in
      switch section {
      case let .profile(viewModel):
        let cell = collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
        cell.configure(by: viewModel)
        return cell

      case let .detail(viewModel):
        let cell = collectionView.dequeue(UserDetailInfoCell.self, indexPath: indexPath)
        cell.configure(by: viewModel)
        return cell

      case let .location(viewModel):
        let cell = collectionView.dequeue(UserLocationCell.self, indexPath: indexPath)
        cell.configure(by: viewModel)
        return cell

      case .dummyProfile:
        return collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)

      case .dummy:
        return collectionView.dequeue(UserDetailInfoCell.self, indexPath: indexPath)
      }
    })
  }

  func setDataSourceConfigureSupplementaryView() {
    dataSource.configureSupplementaryView = { dataSource, collectionView, ofKind, indexPath in
      let section = dataSource.sectionModels[indexPath.section]
      var emptyView: EmptyReusableView {
        collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
      }

      switch ofKind {
      case UICollectionView.elementKindSectionHeader:
        guard let headerViewModel = section.header else { return emptyView }
        let headerView = collectionView.dequeue(UserInfoHeaderView.self, indexPath: indexPath)
        headerView.configure(by: headerViewModel)
        return headerView

      case UICollectionView.elementKindSectionFooter:
        guard section.hasFooter else { return emptyView }
        let footerView = collectionView.dequeue(UserInfoFooterView.self, indexPath: indexPath)
        let isHidden = indexPath.section == dataSource.sectionModels.count - 1
        footerView.hideSeparator(isHidden)
        return footerView

      default:
        return emptyView
      }
    }
  }

  func setNavigationBarStyle() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }

  func resetNavigationBarStyle() {
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
  }
}

// MARK: - Bind UI

private extension UserInformationViewController {
  func bindUI() {
    bindCollectionViewSetDelegate()

    guard needHeaderView else { return }
    bindCloseButtonTapAction()
  }

  func bindCollectionViewSetDelegate() {
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

// MARK: - Bind listener

private extension UserInformationViewController {
  private func bind(listener: UserInformationPresentableListener?) {
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

private extension UserInformationViewController {
  func bindActions() {
    bindViewWillAppearAction()
    bindItemSelectedAction()
    bindDetachAction()
  }

  func bindViewWillAppearAction() {
    rx.viewWillAppear
      .take(1)
      .map { _ in .viewWillAppear }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }

  func bindItemSelectedAction() {
    collectionView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }

  func bindDetachAction() {
    detachAction
      .map { .detach }
      .bind(to: actionRelay)
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding State

private extension UserInformationViewController {
  func bindState(from listener: UserInformationPresentableListener) {
    bindUserInformationSectionsState(from: listener)
  }

  func bindUserInformationSectionsState(from listener: UserInformationPresentableListener) {
    listener.state.map(\.userInformationSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

private extension UserInformationViewController {
  func setupUI() {
    view.backgroundColor = Asset.Colors.backgroundColor.color
    addHeaderViewIfNeeded(to: view)
    view.addSubview(collectionView)

    setDataSourceConfigureSupplementaryView()
    layout()
  }

  func layout() {
    makeHeaderViewConstraintsIfNeeded()
    makeCollectionViewConstraints()
  }

  func makeCollectionViewConstraints() {
    collectionView.snp.makeConstraints {
      if needHeaderView {
        $0.top.equalTo(headerView.snp.bottom)
        $0.leading.trailing.bottom.equalToSuperview()
      } else {
        $0.edges.equalToSuperview()
      }
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserInformationViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    guard dataSource.sectionModels[safe: section]?.header != nil else { return .zero }
    return CGSize(width: collectionView.frame.width, height: UI.headerHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let hasFooter = dataSource.sectionModels[safe: section]?.hasFooter, hasFooter else { return .zero }
    return CGSize(width: collectionView.frame.width, height: UI.footerHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sectionItem = dataSource.sectionModels[safe: indexPath.section]?.items[safe: indexPath.item]
    guard let item = sectionItem else { return .zero }

    switch item {
    case .dummyProfile, .profile:
      return CGSize(width: collectionView.frame.width, height: UI.profileCellHeight)

    case .dummy, .detail:
      return CGSize(width: collectionView.frame.width, height: UI.detailCellHeight)

    case .location:
      return CGSize(width: collectionView.frame.width, height: UI.locationCellHeight)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  fileprivate extension UserInformationViewController {
    func bindDummyUserModel() {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
      guard let randomUser = try? decoder.decode(RandomUser.self, from: RandomUserFixture.data) else { return }

      let userModelTranslator = UserModelTranslatorImpl()
      guard let userModel = userModelTranslator.translateToUserModel(by: randomUser.results).first else { return }

      let mutableSelectedUserModelStream = SelectedUserModelStreamImpl()
      mutableSelectedUserModelStream.updateSelectedUserModel(by: userModel)

      let factories: [UserInfoSectionFactory] = [
        ProfileSectionFactory(),
        BasicInfoSectionFactory()
      ]
      let sectionListFactory = UserInfoSectionListFactoryImpl(factories: factories)

      let state = UserInformationPresentableState()
      let interactor = UserInformationInteractor(
        initialState: state,
        selectedUserModelStream: mutableSelectedUserModelStream,
        userInformationSectionListFactory: sectionListFactory,
        presenter: self
      )
      interactor.action.on(.next(.viewWillAppear))
      interactor.state.map(\.userInformationSections)
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: [])
        .drive(collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
  }

  import SwiftUI

  private let deviceNames: [String] = [
    "iPhone 5s", "iPhone 11 Pro Max"
  ]

  struct UserInformationViewControllerPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
          let viewController = UserInformationViewController().builder
            .with { $0.bindDummyUserModel() }
            .build()

          return UINavigationController(rootViewController: viewController)
        }
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
      }
    }
  }
#endif
