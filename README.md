
<p align="center">
  <img src="https://i.loli.net/2017/08/01/5980361da9759.png" alt="Today">
  <br/><a href="https://cocoapods.org/pods/Today">
  <img alt="Version" src="https://img.shields.io/badge/version-1.1.0-brightgreen.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Meniny-blue.svg">
  <img alt="Build Passing" src="https://img.shields.io/badge/build-passing-brightgreen.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-4.0%2B-orange.svg">
  <br/>
  <img alt="Platforms" src="https://img.shields.io/badge/platform-macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg">
  <img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
  <br/>
  <img alt="Cocoapods" src="https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg">
  <img alt="Carthage" src="https://img.shields.io/badge/carthage-working%20on-red.svg">
  <img alt="SPM" src="https://img.shields.io/badge/swift%20package%20manager-working%20on-red.svg">
  </a>
</p>

## What's this?

`Today` is a tiny library to make using `Date` easier. Written in Swift.

## Requirements

* iOS 8.0+
* macOS 10.10+
* watchOS 2.0+
* tvOS 9.0+
* Xcode 9 with Swift 4

## Installation

#### CocoaPods

```ruby
use_frameworks!
pod 'Today'
```

## Contribution

You are welcome to fork and submit pull requests.

## License

`Today` is open-sourced software, licensed under the `MIT` license.

## Sample

```swift
import Today

func test() {
  let now = Date()
  print("now: \(now)")
  print("now.isToday: \(now.isToday)")
  print("now.isWeekend: \(now.isWeekend)")
  print("now is: \(now.weekdayName.name)")

  let nextDay = now.adding(days: 1)
  print("nextDay: \(nextDay)")
  print("nextDay.isTomorrow: \(nextDay.isTomorrow)")

  let later = Today.compare(date: nextDay, ifLater: now)
  print("nextDay is isLaterThan now: \(later)")

  let todayInNextYear = Today.dateByAdding(1, of: .year, to: now)
  print("todayInNextYear: \(String(describing: todayInNextYear))")
}
```
