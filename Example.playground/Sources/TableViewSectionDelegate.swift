import UIKit

public protocol TableViewSectionDelegate {

    func shouldHighlightRow(at indexPath: IndexPath, in tableView: UITableView) -> Bool
    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView)
}

public extension TableViewSectionDelegate {

    func shouldHighlightRow(at indexPath: IndexPath, in tableView: UITableView) -> Bool {
        return true
    }

    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView) {
        // No-op.
    }
}
