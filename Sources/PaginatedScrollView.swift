import UIKit

public protocol PaginatedScrollViewDataSource: class {
    func numberOfPagesInPaginatedScrollView(_ paginatedScrollView: PaginatedScrollView) -> Int
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, controllerAtIndex index: Int) -> UIViewController
}

public protocol PaginatedScrollViewDelegate: class {
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int)
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveFromIndex index: Int)
}

open class PaginatedScrollView: UIScrollView {
    open weak var viewDataSource: PaginatedScrollViewDataSource?
    open weak var viewDelegate: PaginatedScrollViewDelegate?
    fileprivate unowned var parentController: UIViewController
    fileprivate var currentPage: Int
    fileprivate var shoudEvaluatePageChange = false

    public init(frame: CGRect, parentController: UIViewController, initialPage: Int) {
        self.parentController = parentController
        self.currentPage = initialPage

        super.init(frame: frame)

        #if os(iOS)
            self.isPagingEnabled = true
            self.scrollsToTop = false
        #endif
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.backgroundColor = UIColor.clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func configure() {
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }

        let numPages = self.viewDataSource?.numberOfPagesInPaginatedScrollView(self) ?? 0
        self.contentSize = CGSize(width: self.frame.size.width * CGFloat(numPages), height: self.frame.size.height)

        self.loadScrollViewWithPage(self.currentPage - 1)
        self.loadScrollViewWithPage(self.currentPage)
        self.loadScrollViewWithPage(self.currentPage + 1)
        self.gotoPage(self.currentPage, animated: false)
    }

    fileprivate func loadScrollViewWithPage(_ page: Int) {
        let numPages = self.viewDataSource?.numberOfPagesInPaginatedScrollView(self) ?? 0
        if page >= numPages || page < 0 {
            return
        }

        if let controller = self.viewDataSource?.paginatedScrollView(self, controllerAtIndex: page), controller.view.superview == nil {
            var frame = self.frame
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0
            controller.view.frame = frame

            self.parentController.addChildViewController(controller)
            self.addSubview(controller.view)
            controller.didMove(toParentViewController: self.parentController)
        }
    }

    fileprivate func gotoPage(_ page: Int, animated: Bool) {
        self.loadScrollViewWithPage(page - 1)
        self.loadScrollViewWithPage(page)
        self.loadScrollViewWithPage(page + 1)

        var bounds = self.bounds
        bounds.origin.x = bounds.size.width * CGFloat(page)
        bounds.origin.y = 0
        self.scrollRectToVisible(bounds, animated: animated)
    }
}

extension PaginatedScrollView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.shoudEvaluatePageChange = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.shoudEvaluatePageChange = false
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.shoudEvaluatePageChange {
            let pageWidth = self.frame.size.width
            let page = Int(floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            if page != self.currentPage {
                self.viewDelegate?.paginatedScrollView(self, didMoveToIndex: page)
                self.viewDelegate?.paginatedScrollView(self, didMoveFromIndex: self.currentPage)
            }
            self.currentPage = page

            self.loadScrollViewWithPage(page - 1)
            self.loadScrollViewWithPage(page)
            self.loadScrollViewWithPage(page + 1)
        }
    }
}
