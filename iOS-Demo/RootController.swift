import UIKit

class RootController: UIViewController {
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.alpha = 0
        button.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
        return button
    }()

    lazy var reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reload Pages", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(reloadPages), for: .touchUpInside)
        return button
    }()

    var pages: [UIView] = []

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(dataSource: self)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        generatePages()

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(nextButton)
        view.addSubview(backButton)
        view.addSubview(reloadButton)

        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -16),
            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            reloadButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),
            reloadButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
            reloadButton.heightAnchor.constraint(equalToConstant: 50),
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func nextPage() {
        scrollView.moveToNextPage()
    }

    @objc func previousPage() {
        scrollView.moveToPreviousPage()
    }

    @objc func reloadPages() {
        generatePages()
        scrollView.reloadData()
    }

    private func generatePages() {
        pages = []
        let colorsArray: [UIColor] = [.red, .green, .blue, .cyan, .magenta, .yellow]
        let numberOfPages = Int(arc4random_uniform(10)) + 1  // Generates between 1 and 10 pages

        var lastColorIndex: Int?

        for _ in 0..<numberOfPages {
            var colorIndex: Int

            repeat {
                colorIndex = Int(arc4random_uniform(UInt32(colorsArray.count)))
            } while colorIndex == lastColorIndex

            lastColorIndex = colorIndex

            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = colorsArray[colorIndex]
            pages.append(view)
        }
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
        UIView.animate(withDuration: 0.3) {
            if index == 0 {
                self.backButton.alpha = 0
                self.nextButton.alpha = 1
            } else if index == self.pages.count - 1 {
                self.backButton.alpha = 1
                self.nextButton.alpha = 0
            } else {
                self.backButton.alpha = 1
                self.nextButton.alpha = 1
            }
        }
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, willMoveFromIndex index: Int) {
        print("willMoveFromIndex \(index)")
    }
}
