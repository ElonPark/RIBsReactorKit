//
//  MainTabBarBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol MainTabBarDependency: MainTabBarDependencyUserList, MainTabBarDependencyUserCollection {}

final class MainTabBarComponent: Component<MainTabBarDependency> {

  var userListViewController: UserListPresentable & UserListViewControllable
  var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable
  
  private var randomUserService = Networking<RandomUserService>()
  
  fileprivate var randomUserRepository: RandomUserRepository {
    RandomUserRepositoryImpl(service: randomUserService)
  }
  
  fileprivate var userModelTranslator: UserModelTranslator {
    UserModelTranslatorImpl()
  }
  
  private var mutableUserModelsStream: MutableUserModelDataStream {
    shared { UserModelDataStreamImpl() }
  }
  
  var randomUserUseCase: RandomUserUseCase {
    RandomUserUseCaseImpl(
      repository: randomUserRepository,
      translator: userModelTranslator,
      mutableUserModelsStream: mutableUserModelsStream
    )
  }
  
  override init(dependency: MainTabBarDependency) {
    userListViewController = UserListViewController()
    userCollectionViewController = UserCollectionViewController()
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol MainTabBarBuildable: Buildable {
  func build(withListener listener: MainTabBarListener) -> MainTabBarRouting
}

final class MainTabBarBuilder:
  Builder<MainTabBarDependency>,
  MainTabBarBuildable
{
  
  // MARK: - Initialization & Deinitialization

  override init(dependency: MainTabBarDependency) {
    super.init(dependency: dependency)
  }
  
  // MARK: - Internal methods
  
  func build(withListener listener: MainTabBarListener) -> MainTabBarRouting {
    let component = MainTabBarComponent(dependency: dependency)
    
    let viewControllers = [
      component.userListViewController,
      component.userCollectionViewController
      ].map { UINavigationController(root: $0) }
    
    let viewController = MainTabBarViewController(viewControllers: viewControllers)
    let interactor = MainTabBarInteractor(presenter: viewController)
    interactor.listener = listener
    
    let userListBuilder = UserListBuilder(dependency: component)
    let userCollectionBuilder = UserCollectionBuilder(dependency: component)
    
    return MainTabBarRouter(
      userListBuilder: userListBuilder,
      userCollectionBuilder: userCollectionBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}
