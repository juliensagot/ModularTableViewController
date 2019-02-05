import UIKit

public extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(ofType cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T
        else { fatalError("Failed to dequeue cell of type \(String(describing: cellType)).") }

        return cell
    }

}

