import UIKit

public protocol TableViewSectionDataSource {

    var cellTypes: [UITableViewCell.Type] { get }
    var numberOfRows: Int { get }
    var headerTitle: String? { get }
    var footerTitle: String? { get }

    func registerCellTypes(in tableView: UITableView)
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
}

public extension TableViewSectionDataSource {

    func registerCellTypes(in tableView: UITableView) {
        self.cellTypes.forEach { cellType in
            tableView.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
}
