import UIKit

// MARK: - Constants
private enum DynamicActionSheetConstants {
    static let animationDuration: TimeInterval = 0.3
    static let dismissThreshold: CGFloat = 0.5
    static let topBarHeight: CGFloat = 7
    static let topBarWidth: CGFloat = 36
    static let initialHeight: CGFloat = 100
    static let topBarBottomSpace: CGFloat = 19
    static let closeButtonWidthHeight: CGFloat = 24
    static let closeButtonTopSpace: CGFloat = 17
    static let closeButtonTrailingSpace: CGFloat = 10
}

// MARK: - Protocols
protocol DynamicActionSheetViewControllerDelegate: AnyObject {
    func dynamicActionSheet(_ viewController: DynamicActionSheetViewController, didChangeHeight height: CGFloat)
}

protocol DynamicActionSheetViewController: UIViewController {
    var contentHeight: CGFloat { get }
    var shouldShowCloseButton: Bool { get }
    var canDismissDynamicActionSheet: Bool { get }
    var dynamicActionSheetDelegate: DynamicActionSheetViewControllerDelegate? { get set }

    func popSelf()
    func actionSheetDidDismiss()
    func dismissActionSheet(_ completion: (() -> Void)?)
    func push(viewController: DynamicActionSheetViewController)
}

extension DynamicActionSheetViewController {
    var shouldShowCloseButton: Bool { false }

    func push(viewController: DynamicActionSheetViewController) {
        guard let navigationController = navigationController else { return }

        viewController.dynamicActionSheetDelegate = dynamicActionSheetDelegate
        navigationController.pushViewController(viewController, animated: true)
    }

    func popSelf() {
        guard let navigationController = navigationController else { return }

        navigationController.popViewController(animated: true)
    }

    func actionSheetDidDismiss() {}

    func dismissActionSheet(_ completion: (() -> Void)? = nil) {
        guard let navigationController = navigationController else {
            dismiss(animated: true, completion: completion)
            return
        }

        navigationController.dismiss(animated: true, completion: completion)
    }

    var canDismissDynamicActionSheet: Bool {
        return true
    }
}

protocol DynamicActionSheetControllerDismissalDelegate: AnyObject {
    func manuallyDismissedDynamicActionSheetController()
}

// MARK: - Class
final class DynamicActionSheetController: UIViewController {
    enum Style {
        case `default`
        case noTopGap
        case withCloseButton
        case noTopGapAndNoTopHandle
    }

    private var dynamicActionSheetNavigationController: UINavigationController! {
        didSet {
            dynamicActionSheetNavigationController.delegate = self
        }
    }
    private var dynamicActionSheetNavigationControllerContainer: UIView!
    private var topBarView: UIView!
    private var closeButton: UIButton!
    private var heightConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var whiteBottomConstraint: NSLayoutConstraint!
    private var navigationBottomConstraint: NSLayoutConstraint!
    private var containerView: UIView!
    private var whiteView: UIView!
    private let style: Style
    weak var dismissalDelegate: DynamicActionSheetControllerDismissalDelegate?

    static func create(from presenterViewController: UIViewController,
                       rootViewController: DynamicActionSheetViewController,
                       style: Style = .default) -> DynamicActionSheetController {
        let viewController = DynamicActionSheetController(style: style)

        viewController.set(rootViewController: rootViewController)
        viewController.transitioningDelegate = viewController
        viewController.modalPresentationStyle = .custom

        presenterViewController.present(viewController, animated: true)

        return viewController
    }

    init(style: Style = .default) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        createContainerView()
        createWhiteView()
        switch style {
        case .withCloseButton:
            createCloseButton()
        case .default, .noTopGap:
            createTopBar()
        case .noTopGapAndNoTopHandle:
            // Do nothing, we don't need to add top bar or the close button
            break
        }
        createNavigationController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        resetContainerHeight()
    }

    func set(rootViewController: DynamicActionSheetViewController, animated: Bool = false) {
        if !isViewLoaded {
            loadViewIfNeeded()
        }
        rootViewController.dynamicActionSheetDelegate = self
        dynamicActionSheetNavigationController.setViewControllers([rootViewController], animated: animated)
    }

    func push(_ viewController: DynamicActionSheetViewController, animated: Bool = true) {
        // Use the DynamicActionSheetViewController push to assign the Delegate as well
        guard let lastViewController = dynamicActionSheetNavigationController.viewControllers.last as? DynamicActionSheetViewController else { return }
        lastViewController.push(viewController: viewController)
        if viewController.shouldShowCloseButton {
            createCloseButton()
        } else {
            removeCloseButton()
        }
    }

    func popViewController(animated: Bool) {
        dynamicActionSheetNavigationController.popViewController(animated: animated)
    }

    private func setupView() {
        view.backgroundColor = .clear

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }

    private func resetContainerHeight() {
        guard let viewController = dynamicActionSheetNavigationController.topViewController as? DynamicActionSheetViewController else { return }
        heightConstraint.constant = viewController.contentHeight
    }

    private func createWhiteView() {
        whiteView = UIView(frame: UIScreen.main.bounds)

        view.insertSubview(whiteView, at: 0)

        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            whiteView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        whiteBottomConstraint = whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            whiteView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            whiteView.topAnchor.constraint(equalTo: containerView.topAnchor),
            whiteBottomConstraint
        ])
    }

    private func createContainerView() {
        containerView = UIView(frame: UIScreen.main.bounds)

        view.addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true

        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func createTopBar() {
        topBarView = UIView(frame: .zero)
        topBarView.backgroundColor = .themeColor
        topBarView.isUserInteractionEnabled = false

        containerView.addSubview(topBarView)

        topBarView.translatesAutoresizingMaskIntoConstraints = false
        topBarView.layer.masksToBounds = true
        topBarView.layer.cornerRadius = DynamicActionSheetConstants.topBarHeight * 0.5
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DynamicActionSheetConstants.topBarHeight),
            topBarView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topBarView.widthAnchor.constraint(equalToConstant: DynamicActionSheetConstants.topBarWidth),
            topBarView.heightAnchor.constraint(equalToConstant: DynamicActionSheetConstants.topBarHeight)
        ])
    }

    private func createCloseButton() {
        closeButton = UIButton(type: .system)
        closeButton.addTarget(self, action: #selector(tapAction(_:)), for: .touchUpInside)
        containerView.addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DynamicActionSheetConstants.closeButtonTopSpace),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                  constant: -DynamicActionSheetConstants.closeButtonTrailingSpace),
            closeButton.widthAnchor.constraint(equalToConstant: DynamicActionSheetConstants.closeButtonWidthHeight),
            closeButton.heightAnchor.constraint(equalToConstant: DynamicActionSheetConstants.closeButtonWidthHeight)
        ])
    }

    private func removeCloseButton() {
        guard closeButton != nil else { return }
        closeButton.removeFromSuperview()
        containerView.layoutIfNeeded()
    }

    private func createNavigationController() {
        dynamicActionSheetNavigationControllerContainer = UIView(frame: .zero)
        dynamicActionSheetNavigationControllerContainer.translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .default:
            containerView.insertSubview(dynamicActionSheetNavigationControllerContainer, belowSubview: topBarView)
            NSLayoutConstraint.activate([
                dynamicActionSheetNavigationControllerContainer.topAnchor.constraint(equalTo: topBarView.bottomAnchor,
                                                                                     constant: DynamicActionSheetConstants.topBarBottomSpace)
            ])
        case .noTopGap:
            containerView.insertSubview(dynamicActionSheetNavigationControllerContainer, belowSubview: topBarView)
            NSLayoutConstraint.activate([
                dynamicActionSheetNavigationControllerContainer.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                                                     constant: 0)
            ])
        case .withCloseButton:
            containerView.insertSubview(dynamicActionSheetNavigationControllerContainer, belowSubview: closeButton)
            NSLayoutConstraint.activate([
                dynamicActionSheetNavigationControllerContainer.topAnchor.constraint(equalTo: closeButton.bottomAnchor,
                                                                                     constant: 0)
            ])
        case .noTopGapAndNoTopHandle:
            containerView.addSubview(dynamicActionSheetNavigationControllerContainer)
            NSLayoutConstraint.activate([
                dynamicActionSheetNavigationControllerContainer.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                                                     constant: 0)
            ])
        }

        NSLayoutConstraint.activate([
            dynamicActionSheetNavigationControllerContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dynamicActionSheetNavigationControllerContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        if #available(iOS 11.0, *) {
            navigationBottomConstraint = dynamicActionSheetNavigationControllerContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            navigationBottomConstraint = dynamicActionSheetNavigationControllerContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        navigationBottomConstraint.isActive = true
        heightConstraint = dynamicActionSheetNavigationControllerContainer.heightAnchor.constraint(equalToConstant: DynamicActionSheetConstants.initialHeight)
        heightConstraint.isActive = true

        dynamicActionSheetNavigationController = UINavigationController(nibName: nil, bundle: nil)
        dynamicActionSheetNavigationController.setNavigationBarHidden(true, animated: false)
        dynamicActionSheetNavigationController.delegate = self

        let navigationControllerView: UIView = dynamicActionSheetNavigationController.view

        addChild(dynamicActionSheetNavigationController)
        dynamicActionSheetNavigationControllerContainer.addSubview(navigationControllerView)

        navigationControllerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationControllerView.topAnchor.constraint(equalTo: dynamicActionSheetNavigationControllerContainer.topAnchor),
            navigationControllerView.leadingAnchor.constraint(equalTo: dynamicActionSheetNavigationControllerContainer.leadingAnchor),
            navigationControllerView.trailingAnchor.constraint(equalTo: dynamicActionSheetNavigationControllerContainer.trailingAnchor),
            navigationControllerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        ])
    }

    private func resize(for viewController: DynamicActionSheetViewController) {
        viewController.view.layoutIfNeeded()
        UIView.animate(
            withDuration: DynamicActionSheetConstants.animationDuration,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.heightConstraint.constant = viewController.contentHeight
                self.view.layoutIfNeeded()
            })
    }

    @objc private func tapAction(_ sender: Any) {
        guard let viewController = dynamicActionSheetNavigationController.topViewController as? DynamicActionSheetViewController,
            viewController.canDismissDynamicActionSheet
            else {
                return
        }
        viewController.actionSheetDidDismiss()
        dismissalDelegate?.manuallyDismissedDynamicActionSheetController()
        dismiss(animated: true)
    }

    private func dampScroll(_ y: CGFloat) -> CGFloat {
        guard y < 0 else { return y }

        let d: CGFloat = UIScreen.main.bounds.height
        let c: CGFloat = 0.55

        return (y * d * c) / (d + c * -y)
    }

    @objc private func panAction(_ sender: UIPanGestureRecognizer) {
        guard let viewController = dynamicActionSheetNavigationController.topViewController as? DynamicActionSheetViewController,
            viewController.canDismissDynamicActionSheet
            else {
                return
        }

        let translation = sender.translation(in: sender.view)
        switch sender.state {
        case .changed:
            let y = dampScroll(translation.y)

            bottomConstraint.constant = y
            navigationBottomConstraint.constant = y
            whiteBottomConstraint.constant = max(y, 0)
        case .ended,
             .cancelled,
             .failed:
            let velocity = sender.velocity(in: sender.view)
            let endPosition = velocity.y * 0.01 + translation.y
            if endPosition > heightConstraint.constant * DynamicActionSheetConstants.dismissThreshold {
                viewController.actionSheetDidDismiss()
                dismissalDelegate?.manuallyDismissedDynamicActionSheetController()
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: DynamicActionSheetConstants.animationDuration) {
                    self.bottomConstraint.constant = 0
                    self.navigationBottomConstraint.constant = 0
                    self.whiteBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }

        default:
            break
        }
    }
}

// MARK: - DynamicActionSheetViewControllerDelegate
extension DynamicActionSheetController: DynamicActionSheetViewControllerDelegate {
    func dynamicActionSheet(_ viewController: DynamicActionSheetViewController, didChangeHeight height: CGFloat) {
        guard dynamicActionSheetNavigationController.viewControllers.last == viewController else { return }

        resize(for: viewController)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
private class DynamicActionSheetPresentationController: UIPresentationController {
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundView.alpha = 0

        return backgroundView
    }()

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        containerView.insertSubview(backgroundView, at: 0)
        UIView.animate(withDuration: DynamicActionSheetConstants.animationDuration) {
            self.backgroundView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: DynamicActionSheetConstants.animationDuration) {
            self.backgroundView.alpha = 0
        }
    }
}

extension DynamicActionSheetController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DynamicActionSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DynamicActionSheetController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let position = gestureRecognizer.location(in: containerView)

            return position.y < 0
        } else if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)

            return abs(translation.y) > abs(translation.x)
        }

        return true
    }
}

// MARK: - UINavigationControllerDelegate
extension DynamicActionSheetController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let viewController = viewController as? DynamicActionSheetViewController else { return }

        resize(for: viewController)
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension DynamicActionSheetController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return DynamicActionSheetConstants.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        let isPushing = dynamicActionSheetNavigationController.viewControllers.contains(fromVC)

        let duration = transitionDuration(using: transitionContext)

        var toViewInitialFrame = transitionContext.initialFrame(for: fromVC)
        var fromViewFinalFrame = transitionContext.initialFrame(for: fromVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        if isPushing {
            toViewInitialFrame.origin.x = toViewInitialFrame.width
            fromViewFinalFrame.origin.x = -fromViewFinalFrame.width
        } else {
            toViewInitialFrame.origin.x = -toViewInitialFrame.width
            fromViewFinalFrame.origin.x = fromViewFinalFrame.width
        }

        toView.frame = toViewInitialFrame
        transitionContext.containerView.addSubview(toView)

        UIView.animate(withDuration: duration, animations: {
            toView.frame = toViewFinalFrame
            fromView.frame = fromViewFinalFrame
        }, completion: { (didComplete) in
            transitionContext.completeTransition(didComplete)
        })
    }
}

// MARK: - Accessibility
extension DynamicActionSheetController {
    override func accessibilityPerformEscape() -> Bool {
        tapAction(self)
        return true
    }
}

