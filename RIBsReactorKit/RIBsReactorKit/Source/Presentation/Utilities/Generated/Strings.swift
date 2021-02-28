// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {

  internal enum TabBarTitle {
    /// Collection
    internal static let collection = Strings.tr("Localizable", "tabBarTitle.collection")
    /// List
    internal static let list = Strings.tr("Localizable", "tabBarTitle.list")
  }

  internal enum Unit {
    /// %i
    internal static func age(_ p1: Int) -> String {
      return Strings.tr("Localizable", "unit.age", p1)
    }
  }

  internal enum UserInfoTitle {
    /// Age
    internal static let age = Strings.tr("Localizable", "userInfoTitle.age")
    /// Basic Information
    internal static let basicInfo = Strings.tr("Localizable", "userInfoTitle.basicInfo")
    /// Birthday
    internal static let birthday = Strings.tr("Localizable", "userInfoTitle.birthday")
    /// gender
    internal static let gender = Strings.tr("Localizable", "userInfoTitle.gender")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
