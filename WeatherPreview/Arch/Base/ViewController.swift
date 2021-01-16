import UIKit
import RxSwift
import Reachability

open class ViewController<VM: ViewModelType>: UIViewController, ViewType {
    
    public var alertMessageView: UIView?
    
    public let reachability = try! Reachability()
    private(set) var isConnectionReachable = true
    
    public let disposeBag = DisposeBag()
    
    public typealias ViewModel = VM
    public var viewModel: ViewModel!
    
    public let willAppear = PublishSubject<Void>()
    public let didAppear = PublishSubject<Void>()
    public let willDisappear = PublishSubject<Void>()
    public let didDisappear = PublishSubject<Void>()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.bind(viewModel: self.viewModel)
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear.onNext(())
        addReachabilityObserver()
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear.onNext(())
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willDisappear.onNext(())
    }
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappear.onNext(())
        removeReachabilityObserver()
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    open func bind(viewModel: ViewModel) {
        
        viewModel.subscribeIfNeeded()
    }
    
    // MARK: - Reachability
    
    private func addReachabilityObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
       do{
         try reachability.startNotifier()
       }catch{
         print("could not start reachability notifier")
       }

    }

    private func removeReachabilityObserver() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi, .cellular:
        if !isConnectionReachable {
            let message = "Network is reachable"
            print(message)
            isConnectionReachable = true
            showAlertMessage(with: message)
        }
      case .unavailable, .none:
        if isConnectionReachable {
            let message = "Network not reachable"
            print(message)
            isConnectionReachable = false
            showAlertMessage(with: message)
        }
      }
    }
}
