import UIKit

class PageController: UIViewController {
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}