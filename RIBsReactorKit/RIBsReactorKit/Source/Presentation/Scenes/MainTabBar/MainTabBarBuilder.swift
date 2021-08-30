//
//  MainTabBarBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - MainTabBarDependency

protocol MainTabBarDependency: MainTabBarDependencyUserList, MainTabBarDependencyUserCollection {
  var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable { get }
}

// MARK: - MainTabBarComponent

final class MainTabBarComponent: Component<MainTabBarDependency> {

  fileprivate var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable {
    dependency.mainTabBarViewController
  }

  fileprivate var randomUserRepository: RandomUserRepository {
    RandomUserRepositoryImpl(networkingProvider: Networking())
  }

  fileprivate var userModelTranslator: UserModelTranslator {
    UserModelTranslatorImpl()
  }

  private var mutableUserModelDataStream: MutableUserModelDataStream {
    shared { UserModelDataStreamImpl() }
  }

  var userModelDataStream: UserModelDataStream {
    mutableUserModelDataStream
  }

  var randomUserRepositoryService: RandomUserRepositoryService {
    shared {
      RandomUserRepositoryServiceImpl(
        repository: randomUserRepository,
        translator: userModelTranslator,
        mutableUserModelsStream: mutableUserModelDataStream
      )
    }
  }
}

// MARK: - MainTabBarBuildable

protocol MainTabBarBuildable: Buildable {
  func build(withListener listener: MainTabBarListener) -> MainTabBarRouting
}

// MARK: - MainTabBarBuilder

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
    let viewController = component.mainTabBarViewController
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
