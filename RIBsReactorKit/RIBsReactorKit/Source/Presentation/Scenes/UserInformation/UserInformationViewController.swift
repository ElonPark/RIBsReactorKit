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

  private let detachAction = PublishRelay<Void>()

  // MARK: - UI Components

  private let flowLayout = UICollectionViewFlowLayout().builder
    .scrollDirection(.vertical)
    .build()

  private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).builder
    .backgroundColor(.white)
    .reinforce {
      $0.register(UserProfileCell.self)
      $0.register(UserDetailInfoCell.self)
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

  override func viewDidDisappear(_ animated: Bool) {
    guard isMovingFromParent || isBeingDismissed else { return }
    detachAction.accept(Void())
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

  // MARK: - Private methods

  private static func dataSourceFactory() -> UserInformationDataSource {
    .init(configureCell: { _, collectionView, indexPath, section in
      switch section {
      case let .profile(viewModel):
        let cell = collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
        cell.configure(by: viewModel)
        return cell

      case let .detail(viewModel):
        let cell = collectionView.dequeue(UserDetailInfoCell.self, indexPath: indexPath)
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
      switch ofKind {
      case UICollectionView.elementKindSectionHeader:
        if let headerViewModel = section.header {
          let headerView = collectionView.dequeue(UserInfoHeaderView.self, indexPath: indexPath)
          headerView.configure(by: headerViewModel)
          return headerView
        } else {
          return collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
        }

      case UICollectionView.elementKindSectionFooter:
        if section.hasFooter {
          let footerView = collectionView.dequeue(UserInfoFooterView.self, indexPath: indexPath)
          return footerView
        } else {
          return collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
        }

      default:
        return collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
      }
    }
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
    return CGSize(width: UIScreen.main.bounds.width, height: UI.headerHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let hasFooter = dataSource.sectionModels[safe: section]?.hasFooter, hasFooter else { return .zero }
    return CGSize(width: UIScreen.main.bounds.width, height: UI.footerHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = dataSource.sectionModels[safe: indexPath.section],
          let item = section.items[safe: indexPath.item]
    else {
      return .zero
    }

    switch item {
    case .dummyProfile,
         .profile:
      return CGSize(width: UIScreen.main.bounds.width, height: 250)
    case .dummy,
         .detail:
      return CGSize(width: UIScreen.main.bounds.width, height: 65)
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
