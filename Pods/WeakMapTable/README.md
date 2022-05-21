# WeakMapTable

![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/WeakMapTable.svg)](https://cocoapods.org/pods/WeakMapTable)
[![Build Status](https://github.com/ReactorKit/WeakMapTable/workflows/CI/badge.svg)](https://github.com/ReactorKit/WeakMapTable/actions)
[![CodeCov](https://img.shields.io/codecov/c/github/ReactorKit/WeakMapTable.svg)](https://codecov.io/gh/ReactorKit/WeakMapTable)

A weak-to-strong map table. It is inspired by [`NSMapTable`](https://developer.apple.com/documentation/foundation/nsmaptable) but **guarantees thread safety** and **deals better with weak references**. [`NSMapTable.weakToStrongObjects()`](https://developer.apple.com/documentation/foundation/nsmaptable/1391346-weaktostrongobjects) doesn't free the value object when the key object is deallocated but WeakMapTable does.

## APIs

```swift
public func value(forKey key: Key) -> Value?
public func value(forKey key: Key, default: @autoclosure () -> Value) -> Value
public func forceCastedValue<T>(forKey key: Key, default: @autoclosure () -> T) -> T
public func setValue(_ value: Value?, forKey key: Key)
```

## Installation

**Podfile**

```ruby
pod 'WeakMapTable'
```

## License

WeakMapTable is under MIT license. See the [LICENSE](LICENSE) file for more info.
