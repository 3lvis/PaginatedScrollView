import UIKit

class RootController: UIViewController {
    var pages: [UIViewController] {
        let firstController = UIViewController()
        firstController.view.backgroundColor = UIColor.red

        let secondController = UIViewController()
        secondController.view.backgroundColor = UIColor.green

        let thirdController = UIViewController()
        thirdController.view.backgroundColor = UIColor.purple

        return [firstController, secondController, thirdController]
    }

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(frame: self.view.frame, parentController: self, initialPage: 0)
        view.viewDataSource = self
        view.viewDelegate = self

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
    func numberOfPagesInPaginatedScrollView(_ paginatedScrollView: PaginatedScrollView) -> Int {
        return self.pages.count
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, controllerAtIndex index: Int) -> UIViewController {
        return self.pages[index]
    }
}

extension RootController: PaginatedScrollViewDelegate {
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int) {

    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveFromIndex index: Int) {

    }
}
