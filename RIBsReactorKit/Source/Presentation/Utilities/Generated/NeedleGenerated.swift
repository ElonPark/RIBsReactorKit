

import CoreLocation
import NeedleFoundation
import RIBs

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent") { component in
        return UserInformationDependencybe7700aab05496476ebdProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent") { component in
        return UserInformationDependencya9d2cce9e772d159ee2bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent->UserLocationComponent") { component in
        return UserLocationDependency5cefcfd5d837c6ee54c8Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent->UserLocationComponent") { component in
        return UserLocationDependencyf0dd14e998fd0f122ea0Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent") { component in
        return UserCollectionDependencyc60053073d712d7e03dcProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent") { component in
        return UserListDependencya1faf7e4584bd63fc032Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent") { component in
        return RootDependency3944cc797a4a88956fb5Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->RootComponent->MainTabBarComponent") { component in
        return MainTabBarDependency510c3a1e09ee5fb6fb74Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    
}

// MARK: - Providers

private class UserInformationDependencybe7700aab05496476ebdBaseProvider: UserInformationDependency {
    var selectedUserModelStream: SelectedUserModelStream {
        return userCollectionComponent.selectedUserModelStream
    }
    private let userCollectionComponent: UserCollectionComponent
    init(userCollectionComponent: UserCollectionComponent) {
        self.userCollectionComponent = userCollectionComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent
private class UserInformationDependencybe7700aab05496476ebdProvider: UserInformationDependencybe7700aab05496476ebdBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(userCollectionComponent: component.parent as! UserCollectionComponent)
    }
}
private class UserInformationDependencya9d2cce9e772d159ee2bBaseProvider: UserInformationDependency {
    var selectedUserModelStream: SelectedUserModelStream {
        return userListComponent.selectedUserModelStream
    }
    private let userListComponent: UserListComponent
    init(userListComponent: UserListComponent) {
        self.userListComponent = userListComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent
private class UserInformationDependencya9d2cce9e772d159ee2bProvider: UserInformationDependencya9d2cce9e772d159ee2bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(userListComponent: component.parent as! UserListComponent)
    }
}
private class UserLocationDependency5cefcfd5d837c6ee54c8BaseProvider: UserLocationDependency {


    init() {

    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent->UserInformationComponent->UserLocationComponent
private class UserLocationDependency5cefcfd5d837c6ee54c8Provider: UserLocationDependency5cefcfd5d837c6ee54c8BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent->UserInformationComponent->UserLocationComponent
private class UserLocationDependencyf0dd14e998fd0f122ea0Provider: UserLocationDependency5cefcfd5d837c6ee54c8BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class UserCollectionDependencyc60053073d712d7e03dcBaseProvider: UserCollectionDependency {
    var randomUserRepositoryService: RandomUserRepositoryService {
        return appComponent.randomUserRepositoryService
    }
    var userModelDataStream: UserModelDataStream {
        return appComponent.userModelDataStream
    }
    var imagePrefetchWorker: ImagePrefetchWorking {
        return appComponent.imagePrefetchWorker
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserCollectionComponent
private class UserCollectionDependencyc60053073d712d7e03dcProvider: UserCollectionDependencyc60053073d712d7e03dcBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent as! AppComponent)
    }
}
private class UserListDependencya1faf7e4584bd63fc032BaseProvider: UserListDependency {
    var randomUserRepositoryService: RandomUserRepositoryService {
        return appComponent.randomUserRepositoryService
    }
    var userModelDataStream: UserModelDataStream {
        return appComponent.userModelDataStream
    }
    var imagePrefetchWorker: ImagePrefetchWorking {
        return appComponent.imagePrefetchWorker
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent->UserListComponent
private class UserListDependencya1faf7e4584bd63fc032Provider: UserListDependencya1faf7e4584bd63fc032BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent as! AppComponent)
    }
}
private class RootDependency3944cc797a4a88956fb5BaseProvider: RootDependency {


    init() {

    }
}
/// ^->AppComponent->RootComponent
private class RootDependency3944cc797a4a88956fb5Provider: RootDependency3944cc797a4a88956fb5BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class MainTabBarDependency510c3a1e09ee5fb6fb74BaseProvider: MainTabBarDependency {
    var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable {
        return rootComponent.mainTabBarViewController
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->AppComponent->RootComponent->MainTabBarComponent
private class MainTabBarDependency510c3a1e09ee5fb6fb74Provider: MainTabBarDependency510c3a1e09ee5fb6fb74BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
