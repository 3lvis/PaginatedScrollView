# PaginatedScrollView

[![Version](https://img.shields.io/cocoapods/v/PaginatedScrollView.svg?style=flat)](https://cocoapods.org/pods/PaginatedScrollView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/3lvis/PaginatedScrollView)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20OS%20X%20%7C%20watchOS%20%7C%20tvOS%20-lightgrey.svg)
[![License](https://img.shields.io/cocoapods/l/PaginatedScrollView.svg?style=flat)](https://cocoapods.org/pods/DATAStack)


## Usage

```swift
import UIKit

class RootController: UIViewController {
    let pages = [
        PageController(color: UIColor.redColor()),
        PageController(color: UIColor.greenColor()),
        PageController(color: UIColor.purpleColor())
    ]

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(frame: self.view.frame, parentController: self, initialPage: 0)
        view.viewDataSource = self

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.scrollView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.scrollView.configure()
    }
}

extension RootController: PaginatedScrollViewDataSource {
    func numberOfPagesInPaginatedScrollView(paginatedScrollView: PaginatedScrollView) -> Int {
        return self.pages.count
    }

    func paginatedScrollView(paginatedScrollView: PaginatedScrollView, controllerAtIndex index: Int) -> UIViewController {
        return self.pages[index]
    }
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
