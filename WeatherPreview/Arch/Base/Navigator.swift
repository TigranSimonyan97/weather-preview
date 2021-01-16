import UIKit

public class Navigator {
    
    private let storyboardInstance: StoryboardInstanceType!
    
    private static var window: UIWindow?
    public static func set(window: inout UIWindow?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        self.window = window
    }
    
    public init(_ storyboardInstance: StoryboardInstanceType! = nil) {
        self.storyboardInstance = storyboardInstance
    }
    
    private var visibleController: UIViewController! {
        guard let visibleController = Navigator.window?.visibleViewController() else {
            return nil
        }
        return visibleController
    }
    
    public func createController<VM: ViewModelType, V: ViewController<VM>>(_ controller: V.Type, viewModel: VM) -> V {
        guard let storyboardInstance = self.storyboardInstance else {
            fatalError("For controller creation you must initialize StoryboardInstanceType")
        }
        let storyboard = UIStoryboard(name: storyboardInstance.name, bundle: nil)
        let controller: V = storyboard.instantiateViewController(withIdentifier: V.controllerIdentifier) as! V
        controller.viewModel = viewModel
        return controller
    }
    
    public func createController<C: UIViewController>(_ controller: C.Type) -> C {
        guard let storyboardInstance = self.storyboardInstance else {
            fatalError("For controller creation you must initialize StoryboardInstanceType")
        }
        let storyboard = UIStoryboard(name: storyboardInstance.name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: C.controllerIdentifier) as! C
        return controller
    }
    
    public func root<C: UIViewController>(_ controller: C.Type, withoutNavigationController: Bool = false) {
        let controller: C = createController(C.self)
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window else {
            return
        }
        guard let storyboardInstance = self.storyboardInstance else {
            fatalError("For controller creation you must initialize StoryboardInstanceType")
        }
        guard !withoutNavigationController else {
            window?.rootViewController = controller
            return
        }
        if controller is UITabBarController {
            window?.rootViewController = controller
        } else if let navigationController = storyboardInstance.rootNavigationController {
            navigationController.viewControllers = [controller]
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = controller
        }
    }
    
    public func push<VM: ViewModelType, V: ViewController<VM>>(_ controller: V.Type, viewModel: VM) {
        let controller: V = createController(V.self, viewModel: viewModel)
        visibleController?.navigationController?.pushViewController(controller, animated: true)
    }

    public func pop(count: Int) {
        if let viewControllers = visibleController?.navigationController?.viewControllers {
            let targetIndex = max(0, viewControllers.count - count - 1)
            visibleController?.navigationController?.popToViewController(viewControllers[targetIndex], animated: true)
        }
    }
     
    public func pop() {
        visibleController?.navigationController?.popViewController(animated: true)
    }
    
    public func popToRoot() {
        visibleController?.navigationController?.popToRootViewController(animated: true)
    }
    
    public func modal<VM: ViewModelType, V: ViewController<VM>>(_ controller: V.Type, viewModel: VM, usingNavigationNamed navigationName: String! = nil, modalPresentationStyle: UIModalPresentationStyle = .formSheet, transitioningDelegate: UIViewControllerTransitioningDelegate! = nil) {
        let controller: V = createController(V.self, viewModel: viewModel)
        if let navigationName = navigationName {
            let navigationController = storyboardInstance.navigationController(controllerName: navigationName)!
            navigationController.viewControllers = [controller]
            navigationController.modalPresentationStyle = modalPresentationStyle
            visibleController?.present(navigationController, animated: true)
        } else {
            controller.modalPresentationStyle = modalPresentationStyle
            if let delegate = transitioningDelegate {
                controller.transitioningDelegate = delegate
            }
            visibleController?.present(controller, animated: true)
        }
    }
    
    public func dismiss(completion: (() -> Void)? = nil) {
        visibleController?.dismiss(animated: true) {
            completion?()
        }
    }
    
    public func root<VM: ViewModelType, V: ViewController<VM>>(_ controller: V.Type, viewModel: VM, withoutNavigationController: Bool = false) {
        let controller: V = createController(V.self, viewModel: viewModel)
        
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window else {
            return
        }

        guard !withoutNavigationController else {
            window?.rootViewController = controller
            return
        }

        guard let storyboardInstance = self.storyboardInstance else {
            fatalError("For controller creation you must initialize StoryboardInstanceType")
        }
        
        if let navigationController = storyboardInstance.rootNavigationController {
            navigationController.viewControllers = [controller]
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = controller
        }
    }
}
