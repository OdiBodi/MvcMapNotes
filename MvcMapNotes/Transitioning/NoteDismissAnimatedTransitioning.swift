import UIKit

class NoteDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: .from),
              let viewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let duration = transitionDuration(using: transitionContext)
        let initialFrame = transitionContext.initialFrame(for: viewController)

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) {
            view.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        } completion: { _ in
            let completed = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(completed)
        }
    }
}
