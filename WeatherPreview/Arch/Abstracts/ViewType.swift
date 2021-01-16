import Foundation
import RxSwift

public protocol ViewType where Self.ViewModel: ViewModelType {
    associatedtype ViewModel
    func bind(viewModel: ViewModel)
}

public extension UIViewController {
    static var controllerIdentifier: String {
        return String(describing: self)
    }
}

public extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
