# BetterTableViewController

### Goals
Creating a controller for a `UITableView` with multiple section is often really tedious.
This project aims to make this task as easy as possible by bringing section modularity and type-safe cell dequeuing.


## One controller per section

Our goal is to be able to have a controller per section.
That way we'll have **a very modular table view**.

---

### Step 1: Creating necessary protocols
Let's create two protocols:

```swift
protocol TableViewSectionDataSource {

    var cellTypes: [UITableViewCell.Type] { get }
    var numberOfRows: Int { get }
    var headerTitle: String? { get }
    var footerTitle: String? { get }

    func registerCellTypes(in tableView: UITableView)
    func cellForRow(at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell

}

protocol TableViewSectionDelegate {

    func shouldHighlightRow(at index: Int, in tableView: UITableView) -> Bool
    func didSelectRow(at indexPath: IndexPath, in tableView: UITableView)
}
```

Notice the `registerCellTypes(in tableView: UITableView)` function.
Let's provide a default implementation:

```swift
extension TableViewSectionDataSource {

    func registerCellTypes(in tableView: UITableView) {
        self.cellTypes.forEach { cellType in
            tableView.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
}
```
	
---

### Step 2: `TableViewController` boilerplate

Let's create a basic TableViewController:

```swift
class MyModularTableViewController: UIViewController {

    private let tableView: UITableView {
        return self.view as! UITableView
    }
    
    private let sectionControllers: [TableViewSectionDataSource] = []
        
    // MARK: - View Lifecycle

    override func loadView() {
        self.view = UITableView(frame: UIScreen.main.bounds, style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.sections.forEach { section in
            section.registerCellTypes(in: self.tableView)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}
```

Then implement the `UITableViewDataSource` protocol so we can delegate everything to our section controllers:

```swift
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
```
    
## Type-safe cell dequeuing

`UITableView` requires providing a `String` for dequeuing a cell, which is really prone to typos.
Let's see how we can fix it and make it type-safe.

### `Reusable` protocol to the rescue
	
What if we could automatically provide a unique reuseIdentifier for every `UITableViewCell` classes and subclasses?<br>
Well, we can, with a protocol and a `UITableViewCell` extension:

```swift
protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self) + "ReuseIdentifier"
    }
}

extension UITableViewCell: Reusable {}
```
    
Now every  classes and subclasses of `UITableViewCell` will automatically (thanks to our default implementation) have a unique `reuseIdentifier`, based on their name.

To fully unleash the power of our `Reusable` protocol, we'll add an extension to `UITableView`:

```swift
extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(ofType cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T
        else { fatalError("Failed to dequeue cell of type \(String(describing: cellType)).") }

        return cell
    }
}
```
    
With that simple extension, we're now able to dequeue a cell by providing a type and not a string identifier, as a bonus, the function returns a cell with a correct type,
no more casting 🤟.

## SectionController Example




## Wrap everything together


