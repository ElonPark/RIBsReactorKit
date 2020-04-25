//
//  AppComponent.swift
//  Smithsonian
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

class AppComponent:
  Component<EmptyDependency>,
  RootDependency
{
  
  // MARK: - Initialization & Deinitialization

  init() {
    super.init(dependency: EmptyComponent())
  }
}
