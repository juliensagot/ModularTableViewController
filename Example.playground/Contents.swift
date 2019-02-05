//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyModularTableViewController: UIViewController {

    private var tableView: UITableView {
        return self.view as! UITableView
    }

    private let sectionControllers: [TableViewSectionDataSource] = [
        HelloWorldSectionController(),
        FizzBuzzSectionController()
    ]

    // MARK: - View Lifecycle

    override func loadView() {
        self.view = UITableView(frame: UIScreen.main.bounds, style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sectionControllers.forEach { section in
            section.registerCellTypes(in: self.tableView)
        }
        self.tableView.dataSource = self
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

struct HelloWorldSectionController: TableViewSectionDataSource {

    var cellTypes = [UITableViewCell.self]

    var numberOfRows: Int {
        return 2
    }

    var headerTitle: String? {
        return "Hello World Section Title"
    }

    var footerTitle: String? {
        return "This is a Hello World section footer"
    }

    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: UITableViewCell.self, for: indexPath)

        let texts = ["Hello", "World"]

        cell.textLabel?.text = texts[indexPath.row]

        return cell
    }
}

struct FizzBuzzSectionController: TableViewSectionDataSource {

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
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyModularTableViewController()
