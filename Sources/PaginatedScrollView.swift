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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()

    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    override public func layoutSubviews() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }

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

        var previousViewElement: UIView!

        let numberOfSubViews = dataSource.numberOfPagesInPaginatedScrollView(self)
        for index in 0..<numberOfSubViews {
            let view = dataSource.paginatedScrollView(self, viewAtIndex: index)

            contentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                view.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])

            if previousViewElement == nil {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: previousViewElement.trailingAnchor)
                ])
            }

            previousViewElement = view
        }

        // At this point previousViewElement refers to the last subview, that is the one at the bottom.
        NSLayoutConstraint.activate([
            previousViewElement.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
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

    private func notifyDidMoveToIndex() {
        let pageWidth = scrollView.frame.size.width
        let page = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        if page != currentPage {
            currentPage = page
        }
        delegate?.paginatedScrollView(self, didMoveToIndex: currentPage)
    }
}
