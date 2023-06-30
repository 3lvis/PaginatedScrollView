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
    public weak var dataSource: PaginatedScrollViewDataSource?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        let numberOfSubViews = dataSource?.numberOfPagesInPaginatedScrollView(self) ?? 0
        for index in 0..<numberOfSubViews {
            guard let view = dataSource?.paginatedScrollView(self, viewAtIndex: index) else {
                continue
            }

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
