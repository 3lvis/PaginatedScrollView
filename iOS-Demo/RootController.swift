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
        view.viewDelegate = self
        view.backgroundColor = UIColor.clearColor()

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

extension RootController: PaginatedScrollViewDelegate {
    func paginatedScrollView(paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int) {

    }

    func paginatedScrollView(paginatedScrollView: PaginatedScrollView, didMoveFromIndex index: Int) {
    }
}
