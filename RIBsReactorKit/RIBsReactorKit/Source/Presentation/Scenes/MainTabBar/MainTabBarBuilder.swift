//
//  MainTabBarBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import NeedleFoundation
import RIBs

// MARK: - MainTabBarDependency

protocol MainTabBarDependency: NeedleFoundation.Dependency {
  var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable { get }
}

// MARK: - MainTabBarComponent

final class MainTabBarComponent: NeedleFoundation.Component<MainTabBarDependency> {

  fileprivate var randomUserRepository: RandomUserRepository {
    RandomUserRepositoryImpl(networkingProvider: Networking())
  }

  fileprivate var userModelTranslator: UserModelTranslator {
    UserModelTranslatorImpl()
  }

  private var mutableUserModelDataStream: MutableUserModelDataStream {
    shared { UserModelDataStreamImpl() }
  }

  fileprivate var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable {
    dependency.mainTabBarViewController
  }

  fileprivate var userListComponent: UserListComponent {
    UserListComponent(parent: self)
  }

  fileprivate var userCollectionComponent: UserCollectionComponent {
    UserCollectionComponent(parent: self)
  }
}

extension MainTabBarComponent {
  var randomUserRepositoryService: RandomUserRepositoryService {
    shared {
      RandomUserRepositoryServiceImpl(
        repository: randomUserRepository,
        translator: userModelTranslator,
        mutableUserModelsStream: mutableUserModelDataStream
      )
    }
  }

  var userModelDataStream: UserModelDataStream {
    mutableUserModelDataStream
  }
}

// MARK: - MainTabBarBuildable

protocol MainTabBarBuildable: Buildable {
  func build(withListener listener: MainTabBarListener) -> MainTabBarRouting
}

// MARK: - MainTabBarBuilder

final class MainTabBarBuilder:
  ComponentizedBuilder<MainTabBarComponent, MainTabBarRouting, MainTabBarListener, Void>,
  MainTabBarBuildable
{

  override func build(with component: MainTabBarComponent, _ listener: MainTabBarListener) -> MainTabBarRouting {
    let interactor = MainTabBarInteractor(presenter: component.mainTabBarViewController)
    interactor.listener = listener

    let userListBuilder = UserListBuilder {
      component.userListComponent
    }

    let userCollectionBuilder = UserCollectionBuilder {
      component.userCollectionComponent
    }

    return MainTabBarRouter(
      userListBuilder: userListBuilder,
      userCollectionBuilder: userCollectionBuilder,
      interactor: interactor,
      viewController: component.mainTabBarViewController
    )
  }

  // MARK: - MainTabBarBuildable

  func build(withListener listener: MainTabBarListener) -> MainTabBarRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: Void())
  }
}
