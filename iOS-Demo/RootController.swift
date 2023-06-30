import UIKit

class RootController: UIViewController {
    //    lazy var nextButton: UIButton = {
    //        let button = UIButton(type: .system)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitle("Next", for: .normal)
    //        button.backgroundColor = .black
    //        button.setTitleColor(.white, for: .normal)
    //        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    //        button.layer.cornerRadius = 6
    //        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    //        return button
    //    }()
    //
    //    lazy var backButton: UIButton = {
    //        let button = UIButton(type: .system)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitle("Back", for: .normal)
    //        button.setTitleColor(.black, for: .normal)
    //        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    //        button.alpha = 0
    //        button.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
    //        return button
    //    }()

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
        let view = PaginatedScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
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

        //        view.addSubview(nextButton)
        //        view.addSubview(backButton)
        //
        //        NSLayoutConstraint.activate([
        //            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        //            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
        //            backButton.heightAnchor.constraint(equalToConstant: 50),
        //            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //
        //            nextButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -16),
        //            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 234),
        //            nextButton.heightAnchor.constraint(equalToConstant: 50),
        //            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        //        ])
    }

    //    @objc func nextPage() {
    //        scrollView.goToNextPage(animated: true)
    //    }
    //
    //    @objc func previousPage() {
    //        scrollView.goToPreviousPage(animated: true)
    //    }
}

extension RootController: PaginatedScrollViewDataSource {
    func numberOfPagesInPaginatedScrollView(_ paginatedScrollView: PaginatedScrollView) -> Int {
        return pages.count
    }

    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, viewAtIndex index: Int) -> UIView {
        return pages[index]
    }
}

//@available(iOS 16.0, *)
//extension RootController: PaginatedScrollViewDelegate {
//    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, didMoveToIndex index: Int) {
//        UIView.animate(withDuration: 0.3) {
//            if index == 0 {
//                self.backButton.alpha = 0
//                self.nextButton.alpha = 1
//            } else if index == self.pages.count - 1 {
//                self.backButton.alpha = 1
//                self.nextButton.alpha = 0
//            } else {
//                self.backButton.alpha = 1
//                self.nextButton.alpha = 1
//            }
//        }
//    }
//
//    func paginatedScrollView(_ paginatedScrollView: PaginatedScrollView, willMoveFromIndex index: Int) {
//
//    }
//}
