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
        currentPage = initialPage

        super.init(frame: frame)

        #if os(iOS)
            isPagingEnabled = true
            scrollsToTop = false
        #endif
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        delegate = self
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        decelerationRate = .fast
        backgroundColor = .clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func configure() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }

        let numPages = viewDataSource?.numberOfPagesInPaginatedScrollView(self) ?? 0
        contentSize = CGSize(width: frame.size.width * CGFloat(numPages), height: frame.size.height)

        loadScrollViewWithPage(currentPage - 1)
        loadScrollViewWithPage(currentPage)
        loadScrollViewWithPage(currentPage + 1)
        gotoPage(currentPage, animated: false)
    }

    fileprivate func loadScrollViewWithPage(_ page: Int) {
        let numPages = viewDataSource?.numberOfPagesInPaginatedScrollView(self) ?? 0
        if page >= numPages || page < 0 {
            return
        }

        if let controller = viewDataSource?.paginatedScrollView(self, controllerAtIndex: page), controller.view.superview == nil {
            var frame = self.frame
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0
            controller.view.frame = frame

            parentController.addChild(controller)
            addSubview(controller.view)
            controller.didMove(toParent: parentController)
        }
    }

    fileprivate func gotoPage(_ page: Int, animated: Bool) {
        loadScrollViewWithPage(page - 1)
        loadScrollViewWithPage(page)
        loadScrollViewWithPage(page + 1)

        var bounds = self.bounds
        bounds.origin.x = bounds.size.width * CGFloat(page)
        bounds.origin.y = 0
        scrollRectToVisible(bounds, animated: animated)
    }
}

extension PaginatedScrollView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shoudEvaluatePageChange = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        shoudEvaluatePageChange = false
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shoudEvaluatePageChange {
            let pageWidth = frame.size.width
            let page = Int(floor((contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            if page != currentPage {
                viewDelegate?.paginatedScrollView(self, didMoveToIndex: page)
                viewDelegate?.paginatedScrollView(self, didMoveFromIndex: currentPage)
            }
            currentPage = page

            loadScrollViewWithPage(page - 1)
            loadScrollViewWithPage(page)
            loadScrollViewWithPage(page + 1)
        }
    }
}
