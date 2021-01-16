import Foundation
import CoreData
import RxSwift
import RxCocoa

open class ViewModel: ViewModelType {
    
    public let disposeBag = DisposeBag()
    
    private var needSubscribe = true
    
    public init() {
        
    }
    
    public func subscribeIfNeeded() {
        guard needSubscribe else {
            return
        }
        needSubscribe = false
        subscribe()
    }
    
    /// Do not call directly!!!
    open func subscribe() {
        
    }
    
    public var isLoading = BehaviorRelay<Bool>(value: false)

}
