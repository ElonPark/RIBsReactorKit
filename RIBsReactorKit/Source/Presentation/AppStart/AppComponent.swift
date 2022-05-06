//
//  AppComponent.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/11/14.
//  Copyright © 2021 Elon. All rights reserved.
//

import NeedleFoundation

// MARK: - AppComponent

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

  var imagePrefetchWorker: ImagePrefetchWorking {
    shared { ImagePrefetchWorker() }
  }
}

extension AppComponent {
  private var randomUserRepository: RandomUserRepository {
    RandomUserRepositoryImpl(networkingProvider: Networking())
  }

  private var userModelTranslator: UserModelTranslator {
    UserModelTranslatorImpl()
  }

  private var mutableUserModelDataStream: MutableUserModelDataStream {
    shared { UserModelDataStreamImpl() }
  }
}
