# PaginatedScrollView

[![Version](https://img.shields.io/cocoapods/v/PaginatedScrollView.svg?style=flat)](https://cocoapods.org/pods/PaginatedScrollView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/3lvis/PaginatedScrollView)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS%20-lightgrey.svg)
[![License](https://img.shields.io/cocoapods/l/PaginatedScrollView.svg?style=flat)](https://cocoapods.org/pods/DATAStack)

Simple paginated UIScrollView subclass that supports UIViewControllers as pages. It handles rotation pretty well, too.

<p align="center">
  <img src="https://github.com/3lvis/PaginatedScrollView/blob/master/GitHub/demo.gif?raw=true"/>
</p>

## Usage

```swift
import UIKit

class RootController: UIViewController {
    var pages: [UIViewController] {
        let firstController = UIViewController()
        firstController.view.backgroundColor = UIColor.redColor()

        let secondController = UIViewController()
        secondController.view.backgroundColor = UIColor.greenColor()

        let thirdController = UIViewController()
        thirdController.view.backgroundColor = UIColor.purpleColor()

        return [firstController, secondController, thirdController]
    }

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(frame: view.frame, parentController: self, initialPage: 0)
        view.viewDataSource = self

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.configure()
    }
}

extension RootController: PaginatedScrollViewDataSource {
    func numberOfPagesInPaginatedScrollView(paginatedScrollView: PaginatedScrollView) -> Int {
        return pages.count
    }

    func paginatedScrollView(paginatedScrollView: PaginatedScrollView, controllerAtIndex index: Int) -> UIViewController {
        return pages[index]
    }
}
```

## PaginatedScrollViewDelegate

`UIPageViewController` is kind of lame when it comes to knowing exactly when you have switched to the next page or went back to the previous one. That's the main reason why `PaginatedScrollView` exists.

```swift
protocol PaginatedScrollViewDelegate: class {
    func paginatedScrollView(paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int)
    func paginatedScrollView(paginatedScrollView: PaginatedScrollView, didMoveFromIndex index: Int)
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
