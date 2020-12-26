//
//  UserInfomationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

enum UserInfomationPresentableAction {
  case viewWillAppear
  case detach
}

protocol UserInfomationPresentableListener: class {
  typealias Action = UserInfomationPresentableAction
  typealias State = UserInfomationPresentableState
  
  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

final class UserInfomationViewController:
  BaseViewController,
  UserInfomationPresentable,
  UserInfomationViewControllable,
  HasCollectionView
{
  
  // MARK: - Constants
  
  private enum UI {
    static let headerHeight: CGFloat = 50
    static let footerHeight: CGFloat = 10
  }
  
  typealias UserInfomationDataSource = RxCollectionViewSectionedReloadDataSource<UserInfoSectionModel>

  // MARK: - Properties
  
  weak var listener: UserInfomationPresentableListener?

  private let detachAction = PublishRelay<Void>()
  
  // MARK: - UI Components
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
    // FIXME: - 수정 필요 2020-10-04 03:39:04
//    $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//    $0.itemSize = UICollectionViewFlowLayout.automaticSize
  }
  
  private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.backgroundColor = .white
    $0.register(UserProfileCell.self)
    $0.register(UserDetailInfomationCell.self)
    $0.register(UserInfoHeaderView.self)
    $0.register(UserInfoFooterView.self)
    $0.register(EmptyReusableView.self)
  }
  
  private let dataSource: UserInfomationDataSource
 
  // MARK: - Initialization & Deinitialization

  override init() {
    dataSource = Self.dataSourceFactory()
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
  
  private func bind(listener: UserInfomationPresentableListener?) {
    guard let listener = listener else { return }
    
    // Action
    bindActions(to: listener)
    
    // State
    bindState(from: listener)
  }
  
  // MARK: - Binding Action
  
  private func bindActions(to listener: UserInfomationPresentableListener) {
    bindViewWillAppearAction(to: listener)
    bindDetachAction(to: listener)
  }
  
  private func bindViewWillAppearAction(to listener: UserInfomationPresentableListener) {
    rx.viewWillAppear
      .take(1)
      .map { _ in .viewWillAppear }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
  
  private func bindDetachAction(to listener: UserInfomationPresentableListener) {
    detachAction
      .map { .detach }
      .bind(to: listener.action)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Binding State
  
  private func bindState(from listener: UserInfomationPresentableListener) {
    bindUserInfomationSectionsState(from: listener)
  }
  
  private func bindUserInfomationSectionsState(from listener: UserInfomationPresentableListener) {
    listener.state.map { $0.userInfomationSections }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
    
  // MARK: - Private methods

  private static func dataSourceFactory() -> UserInfomationDataSource {
    return .init(configureCell: { _, collectionView, indexPath, section in
      switch section {
      case .profile(let viewModel):
        let cell = collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
        cell.viewModel = viewModel
        return cell
        
      case .detail(let viewModel):
        let cell = collectionView.dequeue(UserDetailInfomationCell.self, indexPath: indexPath)
        cell.viewModel = viewModel
        return cell
        
      case .dummyProfile:
        return collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
        
      case .dummy:
        return collectionView.dequeue(UserDetailInfomationCell.self, indexPath: indexPath)
      }
    })
  }
  
  private func setDataSourceConfigureSupplementaryView() {
    dataSource.configureSupplementaryView = { dataSource, collectionView, ofKind, indexPath in
      let section = dataSource.sectionModels[indexPath.section]
      switch ofKind {
      case UICollectionView.elementKindSectionHeader:
        guard let headerViewModel = section.header else {
          return collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
        }
        let headerView = collectionView.dequeue(UserInfoHeaderView.self, indexPath: indexPath)
        headerView.viewModel = headerViewModel
        return headerView
        
      case UICollectionView.elementKindSectionFooter:
        guard section.hasFooter else {
          return collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
        }
        let footerView = collectionView.dequeue(UserInfoFooterView.self, indexPath: indexPath)
        return footerView
        
      default:
        return collectionView.dequeue(EmptyReusableView.self, indexPath: indexPath)
      }
    }
  }
}

// MARK: - Layout
extension UserInfomationViewController {
  private func setupUI() {
    self.view.backgroundColor = .white
    self.view.addSubview(collectionView)
    
    setDataSourceConfigureSupplementaryView()
    
    layout()
  }
  
  private func layout() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension UserInfomationViewController: UICollectionViewDelegateFlowLayout {
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
    guard let hasFooter = dataSource.sectionModels[safe: section]?.hasFooter,
      hasFooter else {
        return .zero
    }
    return CGSize(width: UIScreen.main.bounds.width, height: UI.footerHeight)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = dataSource.sectionModels[safe: indexPath.section],
      let item = section.items[safe: indexPath.item] else {
        return .zero
    }
    // FIXME: - 수정 필요 2020-10-04 03:37:41
    switch item {
    case .dummyProfile, .profile:
      return CGSize(width: UIScreen.main.bounds.width, height: 250)
    case .dummy, .detail:
      return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
extension UserInfomationViewController {
  fileprivate func bindDummyUserModel() {
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

    let state = UserInfomationPresentableState()
    let interactor = UserInfomationInteractor(
      initialState: state,
      userModelStream: mutableUserModelStream,
      userInfomationSectionListFactory: sectionListFactory,
      presenter: self
    )
    interactor.action.on(.next(.viewWillAppear))
    interactor.state.map { $0.userInfomationSections }
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
struct UserInfomationViewControllerPreview: PreviewProvider {
  
  static var previews: some SwiftUI.View {
    ForEach(deviceNames, id: \.self) { deviceName in
      UIViewControllerPreview {
        let viewController = UserInfomationViewController().then {
          $0.bindDummyUserModel()
        }
        return UINavigationController(rootViewController: viewController)
      }
      .previewDevice(PreviewDevice(rawValue: deviceName))
      .previewDisplayName(deviceName)
    }
  }
}
#endif
