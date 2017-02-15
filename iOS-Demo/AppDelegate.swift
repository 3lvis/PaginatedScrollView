import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        window.rootViewController = RootController()
        window.makeKeyAndVisible()

        return true
    }
}
