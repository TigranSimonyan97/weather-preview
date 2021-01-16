import Foundation
import RxDataSources

public class DataSourceCreator {
    
    public static func reloadTableViewDataSource<VM, C: TableViewCell<VM>>(_ cellType: C.Type) -> RxTableViewSectionedReloadDataSource<SectionModel<String, VM>> {
        return RxTableViewSectionedReloadDataSource(configureCell: { _, tableView, indexPath, viewModel in
            return CellConstructor(tableView).cell(cellType, viewModel: viewModel, indexPath: indexPath)
        })
    }
    
}
