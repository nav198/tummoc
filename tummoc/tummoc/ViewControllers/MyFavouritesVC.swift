//
//  MyFavouritesVC.swift
//  tummoc
//
//  Created by nav on 26/07/24.
//

import UIKit
import CoreData

class MyFavouritesVC: UIViewController {
    
    let dataTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.register(MyFavouritesTableCell.self, forCellReuseIdentifier: "MyFavouritesTableCell")
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = 55
        table.backgroundColor = .clear
        table.sectionFooterHeight = 0
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var recordsEmptyInfo: UILabel = {
        let label = UILabel()
        label.text = "No Favourites"
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black.withAlphaComponent(0.8)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bookmarkedItems: [ItemData] = []
    // Dictionary to track units
    var itemUnits: [Int: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getBookmarkedItems()
        setupViews()
        initializeUnits()
    }
    
    func getBookmarkedItems(){
        var bookmarkedItems : [ItemData] = []
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {                
                if let items = category.relationship as? Set<Item> {
                    for item in items {
                        // Check if the item is added to the cart
                        if item.isBookmarked {
                            // Convert Core Data Item to your ItemData model if necessary
                            let itemData = ItemData(
                                id: Int(item.id),
                                name: item.name ?? "Unknown",
                                icon: item.icon ?? "", price: Double(item.price),
                                isBookmarked: item.isBookmarked,
                                isAddedToCart: item.isAddedToCart
                            )
                            bookmarkedItems.append(itemData)
                        }
                    }
                }
            }
        } catch {
            print("Failed to fetch categories: \(error)")
        }
        self.bookmarkedItems = bookmarkedItems
    }
    
    func setupViews() {
        dataTable.delegate = self
        dataTable.dataSource = self
        view.addSubview(dataTable)
        
        view.addSubview(recordsEmptyInfo)
        recordsEmptyInfo.isHidden = true
        title = "My Favourites"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dataTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dataTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dataTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dataTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        recordsEmptyInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        recordsEmptyInfo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        recordsEmptyInfo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        recordsEmptyInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func initializeUnits() {
        // Initialize all items with 1 unit
        for (index, _) in bookmarkedItems.enumerated() {
            itemUnits[index] = 1
        }
    }
    
    func getUnit(for index: Int) -> Int {
        return itemUnits[index] ?? 1
    }
    
    func setUnit(_ unit: Int, for index: Int) {
        itemUnits[index] = unit
    }
    
    @objc func addItemAction(_ sender: UIButton) {
        let index = sender.tag
        var currentUnit = getUnit(for: index)

        currentUnit += 1
        setUnit(currentUnit, for: index)
        
        dataTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

extension MyFavouritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookmarkedItems.count > 0 {
            recordsEmptyInfo.isHidden = true
            return bookmarkedItems.count
        } else {
            recordsEmptyInfo.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTable.dequeueReusableCell(withIdentifier: "MyFavouritesTableCell", for: indexPath) as! MyFavouritesTableCell
        cell.selectionStyle = .none
        cell.addButton.tag = indexPath.row
        
        let item = bookmarkedItems[indexPath.row]
        let unit = getUnit(for: indexPath.row)
        cell.titleLabel.text = item.name
        cell.subTitleLabel.text = "\(unit) unit(s)  ₹\(item.price * Double(unit))"

        if let url = URL(string: "\(item.icon)") {
            fetchImage(from: url) { image in
                if let image = image {
                    // Assuming you have an UIImageView outlet or instance
                    cell.thumbnailImageView.image = image
                } else {
                    print("Failed to load image")
                }
            }
        }

        cell.addButton.addTarget(self, action: #selector(addItemAction(_:)), for: .touchUpInside)
        
        return cell
    }
}
