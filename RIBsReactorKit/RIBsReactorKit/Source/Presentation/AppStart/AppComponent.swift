//
//  AppComponent.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/11/14.
//  Copyright © 2021 Elon. All rights reserved.
//

import NeedleFoundation

final class AppComponent: BootstrapComponent, RootDependency {

  var rootBuilder: RootBuildable {
    RootBuilder {
      RootComponent(parent: self)
    }
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

  var userModelDataStream: UserModelDataStream {
    mutableUserModelDataStream
  }
}

private extension AppComponent {
  var randomUserRepository: RandomUserRepository {
    RandomUserRepositoryImpl(networkingProvider: Networking())
  }

  var userModelTranslator: UserModelTranslator {
    UserModelTranslatorImpl()
  }

  var mutableUserModelDataStream: MutableUserModelDataStream {
    shared { UserModelDataStreamImpl() }
  }
}
