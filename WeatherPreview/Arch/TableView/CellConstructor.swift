import UIKit

public class CellConstructor {
    
    private unowned let tableView: UITableView!
    
    private var registeredCells = Set<String>()
    
    public init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    
    public init(_ collectionView: UICollectionView) {
        self.tableView = nil
    }
        
    public func cell<VM, C: TableViewCell<VM>>(_ cellType: C.Type, viewModel: VM, indexPath: IndexPath! = nil) -> UITableViewCell {
        guard let tableView = self.tableView else {
            fatalError("There must be UITableView for for TableViewCell request")
        }
        if !registeredCells.contains(C.cellIdentifier) {
            tableView.register(UINib(nibName: C.cellIdentifier, bundle: nil), forCellReuseIdentifier: C.cellIdentifier)
        }
        let cell: C = {
            if let indexPath = indexPath {
                return tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier, for: indexPath) as! C
            } else {
                return tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier) as! C
            }
        }()
        cell.bind(viewModel: viewModel)
        return cell
    }
    
}
