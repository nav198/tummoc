//
//  MyCartVC.swift
//  tummoc
//
//  Created by nav on 27/07/24.
//

import UIKit
import CoreData

class MyCartVC: UIViewController {
    let screenSize: CGRect = UIScreen.main.bounds
    let dataTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.separatorStyle = .none
        table.register(MyCartTableViewCell.self, forCellReuseIdentifier: "MyCartTableViewCell")
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
    
    var addedToCartItems: [ItemData] = []
    // Dictionary to track units
  
    var itemUnits: [Int: Int] = [:]
    var initialUnits: [Int: Int] = [:] 
    var subtotal: Double = 0.0
    let discountRate: Double = 0.10
    var total: Double = 0.0
    

    var footerView = UIView()
    
    let subTotal : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    var summaryView = SummaryView()
    
    var checkOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("CHECKOUT", for: .normal)
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getCartItemsFromCoreData()
        setupViews()
        initializeUnits()
        recalculateTotals()
    }
    
    func getCartItemsFromCoreData(){
        var cartItems: [ItemData] = []
        
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {
                if let items = category.relationship as? Set<Item> {
                    for item in items {
                        // Check if the item is added to the cart
                        if item.isAddedToCart {
                            // Convert Core Data Item to your ItemData model if necessary
                            let itemData = ItemData(
                                id: Int(item.id),
                                name: item.name ?? "Unknown",
                                icon: item.icon ?? "", price: Double(item.price),
                                isBookmarked: item.isBookmarked,
                                isAddedToCart: item.isAddedToCart
                            )
                            cartItems.append(itemData)
                        }
                    }
                }
            }
        } catch {
            print("Failed to fetch categories: \(error)")
        }
        
        self.addedToCartItems = cartItems
    }
    
    func initializeUnits() {
        for (index, _) in addedToCartItems.enumerated() {
            itemUnits[index] = 1 // Start with 1 unit for each item
            initialUnits[index] = 1 // Track the initial units
        }
    }

    
    func setupViews() {
        dataTable.delegate = self
        dataTable.dataSource = self
        view.addSubview(dataTable)
        
        view.addSubview(footerView)
        footerView.addSubview(summaryView)
        
        // Configure summaryView
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.layer.cornerRadius = 10
        
        // Add subviews to footerView
        footerView.addSubview(checkOutButton)
        footerView.addSubview(summaryView)
        // Configure footerView
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for footerView
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 210) // Adjust as needed
        ])
        
        checkOutButton.addTarget(self, action: #selector(checkoutAction), for: .touchUpInside)
      
        // Set constraints for summaryView and checkOutButton
        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            summaryView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            summaryView.bottomAnchor.constraint(equalTo: checkOutButton.topAnchor, constant: -16),
            
            checkOutButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            checkOutButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            checkOutButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -5),
            checkOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Set text for labels
        summaryView.subTotalLabel.text = "Sub Total"
        summaryView.disCountLabel.text = "Discount"
        summaryView.totalLabel.text = "Total"
        
        // Add other UI elements
        view.addSubview(recordsEmptyInfo)
        recordsEmptyInfo.isHidden = true
        title = "My Cart"
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
        dataTable.bottomAnchor.constraint(equalTo: footerView.topAnchor,constant: 10).isActive = true
        
        recordsEmptyInfo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        recordsEmptyInfo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        recordsEmptyInfo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        recordsEmptyInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
    }
    
    @objc func checkoutAction(){
        if let totalPrice = summaryView.totalPriceLabel.text{
            showToast("Your total bill is \(totalPrice)")
        }
    }
}

extension MyCartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addedToCartItems.count > 0 {
            recordsEmptyInfo.isHidden = true
            return addedToCartItems.count
        } else {
            recordsEmptyInfo.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTable.dequeueReusableCell(withIdentifier: "MyCartTableViewCell", for: indexPath) as! MyCartTableViewCell
        cell.selectionStyle = .none
        
        // Set button tags
        cell.addButton.tag = indexPath.row
        cell.subtractButton.tag = indexPath.row
        
        // Get the item and unit count
        let item = addedToCartItems[indexPath.row]
        let unitCount = itemUnits[indexPath.row] ?? 1
        let initialUnitCount = initialUnits[indexPath.row] ?? 1
        
        // Configure cell
        cell.titleLabel.text = item.name
        cell.subTitleLabel.text = "1 unit/ ₹\(item.price)"
        cell.priceLabel.text = "\(item.price * Double(unitCount))"
        
        if let url = URL(string: item.icon) {
            fetchImage(from: url) { image in
                if let image = image {
                    // Assuming you have an UIImageView outlet or instance
                    cell.thumbnailImageView.image = image
                } else {
                    print("Failed to load image")
                }
            }
        }
        
        // Add target-action for buttons
        cell.addButton.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
        cell.subtractButton.addTarget(self, action: #selector(subtractButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }

}

extension MyCartVC{
   
    @objc func addButtonAction(_ sender: UIButton) {
        let index = sender.tag
        guard var currentUnits = itemUnits[index] else { return }
        
        currentUnits += 1
        itemUnits[index] = currentUnits
        
        // Reload the specific row
        let indexPath = IndexPath(row: index, section: 0)
        dataTable.reloadRows(at: [indexPath], with: .none)
        
        // Recalculate totals
        recalculateTotals()
    }

    @objc func subtractButtonAction(_ sender: UIButton) {
        let index = sender.tag
        guard var currentUnits = itemUnits[index], let initialUnit = initialUnits[index] else { return }
        
        // Ensure currentUnits does not go below the initialUnits
        if currentUnits > initialUnit {
            currentUnits -= 1
            itemUnits[index] = currentUnits
        } else {
            // Optionally handle item removal if units are zero
            itemUnits.removeValue(forKey: index)
        }
        
        // Reload the specific row
        let indexPath = IndexPath(row: index, section: 0)
        dataTable.reloadRows(at: [indexPath], with: .none)
        
        // Recalculate totals
        recalculateTotals()
    }


    func recalculateTotals() {
        subtotal = 0.0
        
        // Calculate subtotal
        for (index, item) in addedToCartItems.enumerated() {
            let unitCount = itemUnits[index] ?? 1
            subtotal += item.price * Double(unitCount)
        }
        
        // Apply discount
        let discount = subtotal * discountRate
        total = subtotal - discount
        
        // Update the summary view with new values
        summaryView.subTotalPriceLabel.text = String(format: "₹ %.2f", subtotal)
        summaryView.disCountPriceLabel.text = String(format: "- ₹ %.2f", discount)
        summaryView.totalPriceLabel.text = String(format: "₹ %.2f", total)
    }

}
