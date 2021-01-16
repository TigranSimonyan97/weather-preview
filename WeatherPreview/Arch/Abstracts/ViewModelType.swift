import Foundation
import RxSwift
import RxCocoa

public protocol ViewModelType {
    
    func subscribeIfNeeded()
    func subscribe()
    
    var isLoading: BehaviorRelay<Bool> { get }
    
}
