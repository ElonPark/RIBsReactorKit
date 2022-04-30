

import CoreLocation
import NeedleFoundation
import RIBs

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

private func parent2(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent.parent
}

// MARK: - Providers

private class UserInformationDependencybe7700aab05496476ebdProvider: UserInformationDependency {
    var selectedUserModelStream: SelectedUserModelStream {
        return userCollectionComponent.selectedUserModelStream
    }
    private let userCollectionComponent: UserCollectionComponent
    init(userCollectionComponent: UserCollectionComponent) {
        self.userCollectionComponent = userCollectionComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent
private func factory496b26e294b421fee4e931742634bcc4288e1d0f(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UserInformationDependencybe7700aab05496476ebdProvider(userCollectionComponent: parent1(component) as! UserCollectionComponent)
}
private class UserInformationDependencya9d2cce9e772d159ee2bProvider: UserInformationDependency {
    var selectedUserModelStream: SelectedUserModelStream {
        return userListComponent.selectedUserModelStream
    }
    private let userListComponent: UserListComponent
    init(userListComponent: UserListComponent) {
        self.userListComponent = userListComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent
private func factory8b6e97f5917e43e50ef990cbd4f040c4db112586(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UserInformationDependencya9d2cce9e772d159ee2bProvider(userListComponent: parent1(component) as! UserListComponent)
}
private class UserLocationDependency5cefcfd5d837c6ee54c8Provider: UserLocationDependency {


    init() {

    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent->UserLocationComponent
private func factorydb3e187f4f072667c251e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UserLocationDependency5cefcfd5d837c6ee54c8Provider()
}
private class UserCollectionDependencyc60053073d712d7e03dcProvider: UserCollectionDependency {
    var randomUserRepositoryService: RandomUserRepositoryService {
        return mainTabBarComponent.randomUserRepositoryService
    }
    var userModelDataStream: UserModelDataStream {
        return mainTabBarComponent.userModelDataStream
    }
    var userCollectionViewController: UserCollectionViewControllable {
        return rootComponent.userCollectionViewController
    }
    private let mainTabBarComponent: MainTabBarComponent
    private let rootComponent: RootComponent
    init(mainTabBarComponent: MainTabBarComponent, rootComponent: RootComponent) {
        self.mainTabBarComponent = mainTabBarComponent
        self.rootComponent = rootComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent
private func factory5b9bb4416b801c66a218f440a4a879867468aba9(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UserCollectionDependencyc60053073d712d7e03dcProvider(mainTabBarComponent: parent1(component) as! MainTabBarComponent, rootComponent: parent2(component) as! RootComponent)
}
private class UserListDependencya1faf7e4584bd63fc032Provider: UserListDependency {
    var randomUserRepositoryService: RandomUserRepositoryService {
        return mainTabBarComponent.randomUserRepositoryService
    }
    var userModelDataStream: UserModelDataStream {
        return mainTabBarComponent.userModelDataStream
    }
    var userListViewController: UserListPresentable & UserListViewControllable {
        return rootComponent.userListViewController
    }
    private let mainTabBarComponent: MainTabBarComponent
    private let rootComponent: RootComponent
    init(mainTabBarComponent: MainTabBarComponent, rootComponent: RootComponent) {
        self.mainTabBarComponent = mainTabBarComponent
        self.rootComponent = rootComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent
private func factoryab3dbf100a151adb58d4f440a4a879867468aba9(_ component: NeedleFoundation.Scope) -> AnyObject {
    return UserListDependencya1faf7e4584bd63fc032Provider(mainTabBarComponent: parent1(component) as! MainTabBarComponent, rootComponent: parent2(component) as! RootComponent)
}
private class RootDependency3944cc797a4a88956fb5Provider: RootDependency {


    init() {

    }
}
/// ^->AppComponent->RootComponent
private func factory264bfc4d4cb6b0629b40e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RootDependency3944cc797a4a88956fb5Provider()
}
private class MainTabBarDependency510c3a1e09ee5fb6fb74Provider: MainTabBarDependency {
    var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable {
        return rootComponent.mainTabBarViewController
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent
private func factoryff9d1aee745bbf1d697cb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return MainTabBarDependency510c3a1e09ee5fb6fb74Provider(rootComponent: parent1(component) as! RootComponent)
}


private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

private func register1() {
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent", factory496b26e294b421fee4e931742634bcc4288e1d0f)
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent", factory8b6e97f5917e43e50ef990cbd4f040c4db112586)
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent->UserLocationComponent", factorydb3e187f4f072667c251e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent->UserLocationComponent", factorydb3e187f4f072667c251e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent", factory5b9bb4416b801c66a218f440a4a879867468aba9)
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent", factoryab3dbf100a151adb58d4f440a4a879867468aba9)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->RootComponent->MainTabBarComponent", factoryff9d1aee745bbf1d697cb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
}

public func registerProviderFactories() {
    register1()
}
