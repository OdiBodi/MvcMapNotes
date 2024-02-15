import UIKit

class NotePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else {
            return .zero
        }
        let bounds = containerView.bounds
        let bottom = containerView.safeAreaInsets.bottom
        let halfHeight = bounds.height / 2
        return CGRect(x: 0, y: halfHeight - bottom, width: bounds.width, height: halfHeight)
    }

    override func containerViewDidLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else {
            return
        }
        presentedView?.removeFromSuperview()
    }
}
