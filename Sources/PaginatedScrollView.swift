import UIKit

public protocol PaginatedScrollViewDataSource: AnyObject {
    func numberOfPagesInPaginatedScrollView(_ paginatedScrollView: PaginatedScrollView) -> Int
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, viewAtIndex index: Int) -> UIView
}

public protocol PaginatedScrollViewDelegate: AnyObject {
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, willMoveFromIndex index: Int)
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int)
}

public class PaginatedScrollView: UIView {
    private var dataSource: PaginatedScrollViewDataSource
    public weak var delegate: PaginatedScrollViewDelegate?

    private var shoudEvaluatePageChange = false
    private var currentPage: Int = 0

    public init(dataSource: PaginatedScrollViewDataSource) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.reloadData()
    }

    public func reloadData() {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        currentPage = 0
        scrollView.setContentOffset(.zero, animated: false)
        notifyDidMoveToIndex()

        var previousViewElement: UIView?
        let numberOfPages = dataSource.numberOfPagesInPaginatedScrollView(self)
        for index in 0..<numberOfPages {
            let view = dataSource.paginatedScrollView(self, viewAtIndex: index)
            contentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                view.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])

            if let previousView = previousViewElement {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: previousView.trailingAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
                ])
            }
            previousViewElement = view
        }

        if let lastView = previousViewElement {
            NSLayoutConstraint.activate([
                lastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }

    public func moveToNextPage() {
        let numberOfPages = dataSource.numberOfPagesInPaginatedScrollView(self)
        if currentPage < numberOfPages - 1 {
            currentPage += 1
            let offsetX = CGFloat(currentPage) * scrollView.frame.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            delegate?.paginatedScrollView(self, willMoveFromIndex: currentPage)
        }
    }

    public func moveToPreviousPage() {
        if currentPage > 0 {
            currentPage -= 1
            let offsetX = CGFloat(currentPage) * scrollView.frame.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            delegate?.paginatedScrollView(self, willMoveFromIndex: currentPage)
        }
    }

    private func notifyDidMoveToIndex() {
        let pageWidth = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        if page != currentPage {
            currentPage = page
        }
        delegate?.paginatedScrollView(self, didMoveToIndex: currentPage)
    }
}

extension PaginatedScrollView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shoudEvaluatePageChange = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        shoudEvaluatePageChange = false
        notifyDidMoveToIndex()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        notifyDidMoveToIndex()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shoudEvaluatePageChange {
            let pageWidth = scrollView.frame.size.width
            let page = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            if page != currentPage {
                delegate?.paginatedScrollView(self, willMoveFromIndex: currentPage)
                currentPage = page
            }
        }
    }
}
