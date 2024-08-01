//
//  DashBoardViewController.swift
//  tummoc
//
//  Created by nav on 24/07/24.
//

import UIKit
import CoreData

var shoppingCartData: [CategoryData] = []

class DashBoardViewController: UIViewController {
 
    let headerView = UIView()
    let backGroundView = UIView()
    let qrActionView = UIView()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "list.dash")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "My Store"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    
    let dataTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.estimatedRowHeight = UITableView.automaticDimension
        table.register(FoodTableCell.self, forCellReuseIdentifier: "FoodTableCell")
        table.register(BeveragesTableCell.self, forCellReuseIdentifier: "BeveragesTableCell")
        table.register(HygieneEssentialsTableCell.self, forCellReuseIdentifier: "HygieneEssentialsTableCell")
        table.register(PoojaDailyNeedsTableViewCell.self, forCellReuseIdentifier: "PoojaDailyNeedsTableViewCell")
        table.register(ElectronicItemsTableViewCell.self, forCellReuseIdentifier: "ElectronicItemsTableViewCell")
        table.backgroundColor = .clear
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViews()
    
       let jSONDecodedStatus = UserDefaults.standard.bool(forKey: "IsJSONDecoded")
//        saveIntoCoreData()
        if jSONDecodedStatus == true{
            print("CORE DATA ALREADY saved so just fetching the core data")
            fetchAndPrintCategories(context: context)
        }else{
            print("FIRST TIME CALLING SO Saved into core data")
            saveIntoCoreData()
        }
        
//            guard let appDelegate =
//              UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Categories") // Find this name in your .xcdatamodeld file
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            
//            do {
//                try managedContext.execute(deleteRequest)
//                print("Removed all core data")
//            } catch let error as NSError {
//                // TODO: handle the error
//                print(error.localizedDescription)
//            }
    }
    
    func setupViews() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemYellow
        headerView.addSubview(menuButton)
        headerView.addSubview(cartButton)
        headerView.addSubview(countView)
        countView.addSubview(countLabel)
        headerView.addSubview(favouriteButton)

        headerView.addSubview(headerLabel)
        
        headerView.layer.cornerRadius = 15
        countView.layer.cornerRadius = 10
        
        view.addSubview(dataTable)
        dataTable.delegate = self
        dataTable.dataSource = self
        
        setupConstraints()
        
        favouriteButton.addTarget(self, action: #selector(myFavouritesAction), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(visitMyCartAction), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(getCategoriesInfo), for: .touchUpInside)
    }
    
    func setupConstraints() {
            dataTable.translatesAutoresizingMaskIntoConstraints = false

            // HeaderView constraints
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: view.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 140)
            ])

            // MenuButton constraints
            NSLayoutConstraint.activate([
                menuButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                menuButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -40),
               
            ])

            // HeaderLabel constraints
            NSLayoutConstraint.activate([
                headerLabel.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 10),
                headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -40)
            ])
        
        NSLayoutConstraint.activate([
               favouriteButton.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -20),
               favouriteButton.heightAnchor.constraint(equalToConstant: 30),
               favouriteButton.widthAnchor.constraint(equalToConstant: 30),
               favouriteButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -40),
               
               cartButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30),
               cartButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -40),
               cartButton.widthAnchor.constraint(equalToConstant: 30),
               cartButton.heightAnchor.constraint(equalToConstant: 30)
           ])
        
        let cartImage = UIImage(systemName: "cart")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
            let scaledCartImage = cartImage?.resized(to: CGSize(width: 26, height: 26))
            
            let favImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
            let scaledFavImage = favImage?.resized(to: CGSize(width: 26, height: 26))
            
            cartButton.setImage(scaledCartImage, for: .normal)
            favouriteButton.setImage(scaledFavImage, for: .normal)
        
        NSLayoutConstraint.activate([
            countLabel.heightAnchor.constraint(equalToConstant: 20),
            countLabel.widthAnchor.constraint(equalToConstant: 20),
            countLabel.centerYAnchor.constraint(equalTo: countView.centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: countView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            countView.heightAnchor.constraint(equalToConstant: 20),
            countView.widthAnchor.constraint(equalToConstant: 20),
            countView.bottomAnchor.constraint(equalTo: cartButton.topAnchor, constant: 7),
            countView.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor,constant: 3)
        ])
        
        // DataTable constraints
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            dataTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dataTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func saveIntoCoreData(){
        guard let jsonURL = Bundle.main.url(forResource: "shopping", withExtension: "json") else {
            print("JSON file not found.")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let totalResponse = try JSONDecoder().decode(ResponseModel.self, from: jsonData)
                        
            shoppingCartData = totalResponse.categories
            
            self.dataTable.reloadData()
            updateCoreData(with: jsonData, context: context)
            
        } catch {
            print("Error loading JSON data: \(error.localizedDescription)")
        }
    }

    func updateCoreData(with jsonData: Data, context: NSManagedObjectContext) {
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let categoriesArray = json["categories"] as? [[String: Any]] {
                
                for categoryDict in categoriesArray {
                    let categoryId = categoryDict["id"] as? Int ?? 0
                    let categoryName = categoryDict["name"] as? String ?? ""

                    // Fetch or create the Category entity
                    let categoryFetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
                    categoryFetchRequest.predicate = NSPredicate(format: "id == %d", categoryId)
                    
                    var category: Categories?
                    let existingCategories = try context.fetch(categoryFetchRequest)
                    if existingCategories.isEmpty {
                        // Create new category
                        category = Categories(context: context)
                    } else {
                        category = existingCategories.first
                    }
                    
                    category?.id = Int32(Int16(categoryId))
                    category?.name = categoryName

                    // Process items for this category
                    if let itemsArray = categoryDict["items"] as? [[String: Any]] {
                        for itemDict in itemsArray {
                            let itemId = itemDict["id"] as? Int ?? 0
                            let itemName = itemDict["name"] as? String ?? ""
                            let itemPrice = itemDict["price"] as? Float ?? 0.0
                            let itemIcon = itemDict["icon"] as? String ?? ""
                            let itemBookmarked = itemDict["isBookmarked"] as? Bool ?? false
                            let itemAddedToCart = itemDict["isAddedToCart"] as? Bool ?? false
                            // Fetch or create the Item entity
                            let itemFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
                            itemFetchRequest.predicate = NSPredicate(format: "id == %d", itemId)
                            
                            var item: Item?
                            let existingItems = try context.fetch(itemFetchRequest)
                            if existingItems.isEmpty {
                                // Create new item
                                item = Item(context: context)
                            } else {
                                item = existingItems.first
                            }
                            
                            item?.id = Int32(Int16(itemId))
                            item?.name = itemName
                            item?.price = itemPrice
                            item?.icon = itemIcon
                            item?.isBookmarked = itemBookmarked
                            item?.isAddedToCart = itemAddedToCart
                            
                         
                            // Add item to category
                            if let category = category {
//                                item?.category = category.relationship
//                                print("EVERY ITEM VALUE \(item)")
                                
                                if let itemValue = item {
//                                    print("ITEM VALUE \(itemValue)")
                                    category.addToRelationship(itemValue)
                                }
                            }
                        }
                    }
                }

                // Save the context
                try context.save()
                UserDefaults.standard.setValue(true, forKey: "IsJSONDecoded")
                fetchAndPrintCategories(context: context)
            }
        } catch {
            print("Failed to parse JSON or save context: \(error)")
        }
    }

    func fetchAndPrintCategories(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            
//            shoppingCartData.removeAll()
            
            for category in categories {
                var categoryModel = CategoryData(id: Int(category.id), name: category.name ?? "Unknown", items: [])
                
                if let items = category.relationship as? Set<Item> {
                    var itemsModel: [ItemData] = []
                    
                    for item in items {
                        let itemData = ItemData(
                            id: Int(item.id),
                            name: item.name ?? "",
                            icon: item.icon ?? "",
                            price: Double(item.price),
                            isBookmarked: item.isBookmarked,
                            isAddedToCart: item.isAddedToCart
                        )
                      
                        itemsModel.append(itemData)
                    }
                    
                    categoryModel.items = itemsModel
                }
                
                shoppingCartData.append(categoryModel)
            }
            cartItemsCount()
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }
    
    func cartItemsCount(){
        var cartItemsCount = 0
        let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {
                if let items = category.relationship as? Set<Item> {
                    for item in items {
                        if item.isAddedToCart == true{
                            cartItemsCount += 1
                        }
                    }
                }
            }
        } catch {
            print("Failed to fetch categories: \(error)")
        }
        self.countLabel.text = "\(cartItemsCount)"
        
        DispatchQueue.main.async {
            self.dataTable.reloadData()
        }
    }


}

extension DashBoardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0 :
            let headerView = CustomTableHeaderView()
            headerView.layer.cornerRadius = 15
            headerView.setTitle("FOOD")
            return headerView
        case 1 :
            let headerView = CustomTableHeaderView()
            headerView.layer.cornerRadius = 15
            headerView.setTitle("BEVERAGES")
            return headerView
        case 2 :
            let headerView = CustomTableHeaderView()
            headerView.layer.cornerRadius = 15
            headerView.setTitle("HYGIENE AND ESSENTIALS")
            return headerView
        case 3 :
            let headerView = CustomTableHeaderView()
            headerView.layer.cornerRadius = 15
            headerView.setTitle("POOJA AND DAILY NEEDS")
            return headerView
        case 4 :
            let headerView = CustomTableHeaderView()
            headerView.layer.cornerRadius = 15
            headerView.setTitle("ELECTRONIC ITEMS")
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0 :
            let cell = dataTable.dequeueReusableCell(withIdentifier: "FoodTableCell", for: indexPath) as! FoodTableCell
            let _ = cell.indexPathValue
            cell.monuCollectionView.reloadData()
            cell.addedToCartAction = { status in
                if status == true{
                    self.cartItemsCount()
                }
            }
            return cell
        case 1 :
            let cell = dataTable.dequeueReusableCell(withIdentifier: "BeveragesTableCell", for: indexPath) as! BeveragesTableCell
            cell.monuCollectionView.reloadData()
            cell.addedToCartAction = { status in
                if status == true{
                    self.cartItemsCount()
                }
            }
            return cell
        case 2 :
            let cell = dataTable.dequeueReusableCell(withIdentifier: "HygieneEssentialsTableCell", for: indexPath) as! HygieneEssentialsTableCell
            cell.monuCollectionView.reloadData()
            cell.addedToCartAction = { status in
                if status == true{
                    self.cartItemsCount()
                }
            }
            return cell
        case 3 :
            let cell = dataTable.dequeueReusableCell(withIdentifier: "PoojaDailyNeedsTableViewCell", for: indexPath) as! PoojaDailyNeedsTableViewCell
            cell.monuCollectionView.reloadData()
            cell.addedToCartAction = { status in
                if status == true{
                    self.cartItemsCount()
                }
            }
            return cell
        case 4 :
            let cell = dataTable.dequeueReusableCell(withIdentifier: "ElectronicItemsTableViewCell", for: indexPath) as! ElectronicItemsTableViewCell
            cell.monuCollectionView.reloadData()
            cell.addedToCartAction = { status in
                if status == true{
                    self.cartItemsCount()
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DashBoardViewController{
    @objc func myFavouritesAction(){
        let vc = MyFavouritesVC()
        self.navigationController?.pushViewController(vc, animated: true)
    } 
    
    @objc func visitMyCartAction() {
        let vc = MyCartVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension DashBoardViewController{
    @objc func closeAction(){
        self.qrActionView.isHidden = true
        self.backGroundView.removeFromSuperview()
        self.dataTable.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @objc func getCategoriesInfo() {
        self.qrActionView.isHidden = false
        view.addSubview(backGroundView)
        
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.backgroundColor = .systemGray.withAlphaComponent(0.8)
        
        dataTable.addSubview(backGroundView)
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        qrActionView.layer.cornerRadius = 10
        qrActionView.layer.borderWidth = 0.1
        qrActionView.translatesAutoresizingMaskIntoConstraints = false
        qrActionView.backgroundColor = .white
//        self.dataTable.isUserInteractionEnabled = false
     
        backGroundView.addSubview(qrActionView)
    
        let closeBtn: UIButton = {
            let btn = UIButton(type: .custom)
            btn.tintColor = .red
            let closeImage = UIImage(systemName: "xmark.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22))
            btn.setImage(closeImage, for: .normal)
            btn.contentMode = .scaleAspectFill
            btn.isUserInteractionEnabled = true
            btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
    
        qrActionView.addSubview(closeBtn)
        
        let myCategoriesLabel: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .black
            lbl.text = "Categories"
            lbl.font =  UIFont.systemFont(ofSize: 20, weight: .semibold)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
                
        stackView.removeAllArrangedSubviews()
        qrActionView.addSubview(myCategoriesLabel)
        qrActionView.addSubview(stackView)
        
        let labels = ["Food", "Gifts", "Drinks", "Stationary", "Birthday","Apparels"]
        let colors: [UIColor] = [UIColor.secondaryLabel.withAlphaComponent(0.3), .systemOrange, .systemGreen, .red, .blue,.purple]
        
        // Add rows of labels and views to stack view
        for i in 0..<6 {
            let rowView = UIView()
            rowView.backgroundColor = .systemGray5
            rowView.layer.cornerRadius = 10
            
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.alignment = .center
            
            let colorView = UIView()
            colorView.backgroundColor = colors[i] // Assigning different colors
            colorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            colorView.layer.cornerRadius = 15
            rowStackView.addArrangedSubview(colorView)
            
            let label = UILabel()
            label.text = labels[i]
            rowStackView.addArrangedSubview(label)
            
            rowView.addSubview(rowStackView)
            stackView.addArrangedSubview(rowView)
            
            // Constraints for rowStackView
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rowStackView.topAnchor.constraint(equalTo: rowView.topAnchor),
                rowStackView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
                rowStackView.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
                rowStackView.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
            ])
        }
                
        NSLayoutConstraint.activate([
            qrActionView.centerXAnchor.constraint(equalTo: dataTable.centerXAnchor, constant: 0),
            qrActionView.centerYAnchor.constraint(equalTo: dataTable.centerYAnchor, constant: 0),
            qrActionView.heightAnchor.constraint(equalToConstant: 280),
            qrActionView.widthAnchor.constraint(equalToConstant: view.frame.width - 60),
            
            closeBtn.heightAnchor.constraint(equalToConstant: 35),
            closeBtn.widthAnchor.constraint(equalToConstant: 35),
            closeBtn.topAnchor.constraint(equalTo: qrActionView.topAnchor, constant: 5),
            closeBtn.trailingAnchor.constraint(equalTo: qrActionView.trailingAnchor, constant: -10),
            
            myCategoriesLabel.topAnchor.constraint(equalTo: qrActionView.topAnchor, constant: 10),
            myCategoriesLabel.centerXAnchor.constraint(equalTo: qrActionView.centerXAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: qrActionView.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: qrActionView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: qrActionView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: qrActionView.bottomAnchor, constant: -10)
        ])
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
