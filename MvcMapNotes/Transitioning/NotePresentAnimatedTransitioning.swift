import UIKit

class NotePresentAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: .to),
              let viewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let duration = transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.finalFrame(for: viewController)

        view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)

        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [.curveEaseOut]) {
            view.frame = finalFrame
        } completion: { _ in
            let completed = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(completed)
        }
    }
}
