import UIKit

struct SplitModuleFactory {
    func module() -> UISplitViewController {
        let viewController = UISplitViewController(style: .doubleColumn)
        viewController.preferredDisplayMode = .oneBesideSecondary
        return viewController
    }
}
