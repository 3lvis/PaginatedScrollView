import UIKit

@available(iOS 16.0, *)
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

    let clock = ContinuousClock()

    lazy var pages: [UIViewController] = {
        var pages = [UIViewController]()

        let colorsArray = [UIColor.red, UIColor.green, UIColor.blue,
                           UIColor.cyan, UIColor.magenta, UIColor.yellow]

        for _ in 0..<100000 {
            let controller = UIViewController()
            controller.view.backgroundColor = colorsArray[Int(arc4random_uniform(UInt32(colorsArray.count)))] as UIColor
            pages.append(controller)
        }

        return pages
    }()

    lazy var scrollView: PaginatedScrollView = {
        let view = PaginatedScrollView(frame: self.view.frame, parentController: self, initialPage: 0)
        view.viewDataSource = self
        view.viewDelegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)

        view.addSubview(nextButton)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -16),
            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let result = clock.measure {
            scrollView.configure()
        }
        print(result)
    }

    @objc func nextPage() {
        scrollView.goToNextPage(animated: true)
    }

    @objc func previousPage() {
        scrollView.goToPreviousPage(animated: true)
    }
}

@available(iOS 16.0, *)
extension RootController: PaginatedScrollViewDataSource {
    func numberOfPagesInPaginatedScrollView(_ paginatedScrollView: PaginatedScrollView) -> Int {
        return pages.count
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, controllerAtIndex index: Int) -> UIViewController {
        return pages[index]
    }
}

@available(iOS 16.0, *)
extension RootController: PaginatedScrollViewDelegate {
    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int) {
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

    }
}
