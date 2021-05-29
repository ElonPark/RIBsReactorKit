//
//  UserInformationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import ReactorKit
import RIBs
import RxCocoa
import RxDataSources
import RxSwift

// MARK: - UserInformationPresentableAction

enum UserInformationPresentableAction {
  case viewWillAppear
  case detach
}

// MARK: - UserInformationPresentableListener

protocol UserInformationPresentableListener: AnyObject {
  typealias Action = UserInformationPresentableAction
  typealias State = UserInformationPresentableState

  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - UserInformationViewController

final class UserInformationViewController:
  BaseViewController,
  UserInformationPresentable,
  UserInformationViewControllable,
  HasCollectionView
{

  // MARK: - Constants

  private enum UI {
    static let headerHeight: CGFloat = 50
    static let footerHeight: CGFloat = 10
  }

  typealias UserInformationDataSource = RxCollectionViewSectionedReloadDataSource<UserInfoSectionModel>

  // MARK: - Properties

  weak var listener: UserInformationPresentableListener?

  // MARK: - UI Components

  private let flowLayout = UICollectionViewFlowLayout().builder
    .scrollDirection(.vertical)
    .build()

  private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).builder
    .backgroundColor(.white)
    .reinforce {
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
    restoreNavigationBarStyle()
  }

  // MARK: - Private methods

  private static func dataSourceFactory() -> UserInformationDataSource {
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

  private func setDataSourceConfigureSupplementaryView() {
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

  private func setNavigationBarStyle() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }

  private func restoreNavigationBarStyle() {
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
  }

  // MARK: - Binding

  private func bindUI() {
    bindCollectionViewSetDelegate()
  }

  private func bindCollectionViewSetDelegate() {
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }

  private func bind(listener: UserInformationPresentableListener?) {
    guard let listener = listener else { return }
    bindActions(to: listener)
    bindState(from: listener)
  }

  // MARK: - Binding Action

  private func bindActions(to listener: UserInformationPresentableListener) {
    bindViewWillAppearAction(to: listener)
    bindDetachAction(to: listener)
  }

  private func bindViewWillAppearAction(to listener: UserInformationPresentableListener) {
    rx.viewWillAppear
      .take(1)
      .map { _ in .viewWillAppear }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  private func bindDetachAction(to listener: UserInformationPresentableListener) {
    detachAction
      .map { .detach }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }

  // MARK: - Binding State

  private func bindState(from listener: UserInformationPresentableListener) {
    bindUserInformationSectionsState(from: listener)
  }

  private func bindUserInformationSectionsState(from listener: UserInformationPresentableListener) {
    listener.state.map(\.userInformationSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

extension UserInformationViewController {
  private func setupUI() {
    view.addSubview(collectionView)

    setDataSourceConfigureSupplementaryView()
    layout()
  }

  private func layout() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
      return CGSize(width: collectionView.frame.width, height: 250)

    case .dummy, .detail:
      return CGSize(width: collectionView.frame.width, height: 65)

    case .location:
      return CGSize(width: collectionView.frame.width, height: 250)
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

      let mutableUserModelStream = UserModelStreamImpl()
      mutableUserModelStream.updateUserModel(by: userModel)

      let factories: [UserInfoSectionFactory] = [
        ProfileSectionFactory(),
        BasicInfoSectionFactory()
      ]
      let sectionListFactory = UserInfoSectionListFactoryImpl(factories: factories)

      let state = UserInformationPresentableState()
      let interactor = UserInformationInteractor(
        initialState: state,
        userModelStream: mutableUserModelStream,
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

  @available(iOS 13.0, *)
  struct UserInformationViewControllerPreview: PreviewProvider {

    static var previews: some SwiftUI.View {
      ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
          let viewController = UserInformationViewController().builder
            .reinforce { $0.bindDummyUserModel() }
            .build()

          return UINavigationController(rootViewController: viewController)
        }
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
      }
    }
  }
#endif
