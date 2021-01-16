import UIKit
import RxSwift

open class TableViewCell<VM: ViewModelType>: UITableViewCell, ViewType, CellType {
    
    public let disposeBag = DisposeBag()
    public private(set) var reusableDisposeBag = DisposeBag()
    
    public typealias ViewModel = VM
    
    open func bind(viewModel: ViewModel) {
        viewModel.subscribeIfNeeded()
    }
    public func set(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? ViewModel else {
            fatalError("Can`t cast ViewModelType в \(String(describing: ViewModel.self))")
        }
        self.bind(viewModel: viewModel)
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        reusableDisposeBag = DisposeBag()
    }
    
}
