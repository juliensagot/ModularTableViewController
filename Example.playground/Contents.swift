//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

final class MyModularTableViewController: UIViewController {

    private var tableView: UITableView {
        return self.view as! UITableView
    }

    private let sectionControllers: [TableViewSectionDataSource] = [
        HelloWorldSectionController(),
        MultiCellTypesSectionController(),
        FizzBuzzSectionController()
    ]

    // MARK: - View Lifecycle

    override func loadView() {
        self.view = UITableView(frame: UIScreen.main.bounds, style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sectionControllers.forEach { sectionController in
            sectionController.registerCellTypes(in: self.tableView)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension MyModularTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionControllers[section].numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionController = self.sectionControllers[indexPath.section]
        return sectionController.cellForRow(at: indexPath, in: tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionControllers.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionControllers[section].headerTitle
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sectionControllers[section].footerTitle
    }
}

extension MyModularTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let sectionDelegate = self.sectionControllers[indexPath.section] as? TableViewSectionDelegate
        else { return true }

        return sectionDelegate.shouldHighlightRow(at: indexPath, in: self.tableView)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sectionDelegate = self.sectionControllers[indexPath.section] as? TableViewSectionDelegate {
            sectionDelegate.didSelectRow(at: indexPath, in: self.tableView)
        }
    }
}

// ---------------------------------------------------------------------------

struct HelloWorldSectionController: TableViewSectionDataSource, TableViewSectionDelegate {

    var cellTypes = [UITableViewCell.self]

    var numberOfRows: Int {
        return 2
    }

    var headerTitle: String? {
        return "Hello World Section Title"
    }

    var footerTitle: String? {
        return "This is a Hello World section footer."
    }

    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, for: indexPath)

        let texts = ["Hello", "World"]
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }

    func shouldHighlightRow(at indexPath: IndexPath, in tableView: UITableView) -> Bool {
        return false
    }
}

// ---------------------------------------------------------------------------

struct MultiCellTypesSectionController: TableViewSectionDataSource, TableViewSectionDelegate {

    var cellTypes: [UITableViewCell.Type] = [UITableViewCell.self, SwitchControlTableViewCell.self]

    var numberOfRows: Int {
        return 2
    }

    var headerTitle: String? {
        return "Multi cell-types section"
    }

    var footerTitle: String? {
        return "My great footer title."
    }

    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(ofType: SwitchControlTableViewCell.self, for: indexPath)
            cell.textLabel?.text = "Turn on some feature"
            cell.switchControl.setOn(true, animated: false)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, for: indexPath)
            cell.textLabel?.textColor = cell.tintColor
            cell.textLabel?.text = "Toggle Switch"
            return cell
        default:
            fatalError()
        }
    }

    func shouldHighlightRow(at indexPath: IndexPath, in tableView: UITableView) -> Bool {
        return indexPath.row == 1
    }

    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.row == 1 else { return }
        guard let switchControlCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? SwitchControlTableViewCell else { return }

        switchControlCell.switchControl.setOn(!switchControlCell.switchControl.isOn, animated: true)
    }

}

// ---------------------------------------------------------------------------

struct FizzBuzzSectionController: TableViewSectionDataSource, TableViewSectionDelegate {

    var cellTypes = [UITableViewCell.self]

    var numberOfRows: Int {
        return 3
    }

    var headerTitle: String? {
        return "FizzBuzz Section Title"
    }

    var footerTitle: String? {
        return nil
    }

    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, for: indexPath)
        let texts = ["Fizz", "Buzz", "FizzBuzz"]
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }

    func shouldHighlightRow(at indexPath: IndexPath, in tableView: UITableView) -> Bool {
        return false
    }
}

// ---------------------------------------------------------------------------

final class SwitchControlTableViewCell: UITableViewCell {

    var switchControl: UISwitch {
        return self.accessoryView as! UISwitch
    }

    // MARK: - Object Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryView = UISwitch()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented.")
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyModularTableViewController()
