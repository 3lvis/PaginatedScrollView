import UIKit

class RootController: UIViewController {
    lazy var pages: [UIView] = {
        var pages = [UIView]()

        let colorsArray = [UIColor.red, UIColor.green, UIColor.blue,
                           UIColor.cyan, UIColor.magenta, UIColor.yellow]

        for _ in 0..<10 {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = colorsArray[Int(arc4random_uniform(UInt32(colorsArray.count)))] as UIColor
            pages.append(view)
        }

        return pages
    }()

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(dataSource: self)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        print("didMoveToIndex \(index)")
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, willMoveFromIndex index: Int) {
        print("willMoveFromIndex \(index)")
    }
}
