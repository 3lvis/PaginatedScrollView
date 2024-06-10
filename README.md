# PaginatedScrollView

[![Version](https://img.shields.io/cocoapods/v/PaginatedScrollView.svg?style=flat)](https://cocoapods.org/pods/PaginatedScrollView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/3lvis/PaginatedScrollView)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS%20-lightgrey.svg)
[![License](https://img.shields.io/cocoapods/l/PaginatedScrollView.svg?style=flat)](https://cocoapods.org/pods/DATAStack)

Simple paginated UIScrollView subclass that allows pagination of UIViews using a DataSource approach.

<p align="center">
  <img src="https://github.com/3lvis/PaginatedScrollView/blob/master/GitHub/demo.gif?raw=true"/>
</p>

## Usage

```swift
import UIKit

class RootController: UIViewController {
    var pages: [UIView] = []

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(dataSource: self)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupPages() {
        let firstPage = UIView()
        firstPage.backgroundColor = .red
        pages.append(firstPage)

        let secondPage = UIView()
        secondPage.backgroundColor = .green
        pages.append(secondPage)

        let thirdPage = UIView()
        thirdPage.backgroundColor = .blue
        pages.append(thirdPage)
    }
}

extension RootController: PaginatedScrollViewDataSource {
    func numberOfPagesInPaginatedScrollView(_ paginatedScrollView: PaginatedScrollView) -> Int {
        return pages.count
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, viewAtIndex index: Int) -> UIView {
        return pages[index]
    }
}

extension RootController: PaginatedScrollViewDelegate {
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int) {
        print("Did move to page \(index)")
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, willMoveFromIndex index: Int) {
        print("Will move from page \(index)")
    }
}
```

## Methods
```swift
// Reloads all pages.
public func reloadData()

// Moves to the next page.
public func moveToNextPage()

// Moves to the previous page.
public func moveToPreviousPage()
```

## PaginatedScrollViewDelegate

`UIPageViewController` is kind of lame when it comes to knowing exactly when you have switched to the next page or went back to the previous one. That's the main reason why `PaginatedScrollView` exists.

```swift
public protocol PaginatedScrollViewDelegate: AnyObject {
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, willMoveFromIndex index: Int)
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int)
}
```

## Installation

**PaginatedScrollView** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PaginatedScrollView'
```

**PaginatedScrollView** is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "3lvis/PaginatedScrollView"
```

## License

**PaginatedScrollView** is available under the MIT license. See the LICENSE file for more info.

## Author

Elvis Nuñez, [@3lvis](https://twitter.com/3lvis)
