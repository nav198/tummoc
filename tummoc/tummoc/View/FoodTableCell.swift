//
//  shoppingCartTableCell.swift
//  tummoc
//
//  Created by nav on 24/07/24.
//

import UIKit
import CoreData

class FoodTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let monuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var addedToCartAction: ((Bool) -> Void)?
    var indexPathValue: IndexPath?
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        // Initialize UICollectionView
        monuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        monuCollectionView.dataSource = self
        monuCollectionView.delegate = self
        monuCollectionView.backgroundColor = UIColor.clear
        
        monuCollectionView.register(shoppingCartCollectionCell.self, forCellWithReuseIdentifier: "shoppingCartCollectionCell")
        
        // Add UICollectionView to cell's content view
        contentView.addSubview(monuCollectionView)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Constraints for UICollectionView
        NSLayoutConstraint.activate([
            monuCollectionView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            monuCollectionView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            monuCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            monuCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let FoodItemsCount = shoppingCartData.filter({$0.name == "Food"}).first?.items?.count ?? 0
        return FoodItemsCount
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: monuCollectionView.bounds.width/1.7, height: monuCollectionView.bounds.width/1.15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoppingCartCollectionCell", for: indexPath) as! shoppingCartCollectionCell
        
        guard let itemsValue = shoppingCartData.filter({ $0.name == "Food" }).first?.items else { return cell }
        cell.productNameLabel.text = itemsValue[indexPath.row].name
        
        cell.priceLabel.text = "Rs \(itemsValue[indexPath.row].price)"
        
        let item = itemsValue[indexPath.row]
    
        if let url = URL(string: "\(itemsValue[indexPath.row].icon)") {
            fetchImage(from: url) { image in
                if let image = image {
                    // Assuming you have an UIImageView outlet or instance
                    cell.thumbnailImageView.image = image
                } else {
                    print("Failed to load image")
                }
            }
        }

        
        if itemsValue[indexPath.row].isBookmarked == true{
            cell.addFavouriteButton.isSelected = true
        }
        
        cell.configure(with: item, indexPath: indexPath)
            
        cell.addToFavourtiesCallBack = { [weak self] indexPath in
            self?.addToFavouritesAction(at: indexPath)
        }
        
        cell.addingToCartCallBack = { [weak self] indexPath in
            self?.addingToCartAction(at: indexPath)
        }
     
        return cell
    }
        
    func addingToCartAction(at indexPath: IndexPath) {
        
        guard var category = shoppingCartData.first(where: { $0.name == "Food" }),
              var itemsValue = category.items,
              indexPath.row < itemsValue.count else {
            print("Invalid indexPath or category.")
            return
        }
        
        var item = itemsValue[indexPath.row]
        item.isAddedToCart = true // Explicitly add to cart

        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", item.id)
        
        context.perform {
            do {
                let results = try context.fetch(fetchRequest)
                
                let cartItem: Item
                
                if let existingItem = results.first {
                    // Update existing item
                    cartItem = existingItem
                } else {
                    // Create new item if not found
                    cartItem = Item(context: context)
                    cartItem.id = Int32(item.id)
                }
                
                // Update the cart item attributes
                cartItem.name = item.name
                cartItem.icon = item.icon
                cartItem.price = Float(item.price)
                cartItem.isBookmarked = item.isBookmarked
                cartItem.isAddedToCart = item.isAddedToCart
                
                try context.save()
                self.fetchAndPrintCategories(context: context)
                
                DispatchQueue.main.async {
                    self.addedToCartAction?(true)
                    showToast("Item added to cart successfully")
                }
            } catch let nsError as NSError {
                // Log the error
                print("Failed to update or save item: \(nsError.localizedDescription)")
                print("User Info: \(nsError.userInfo)")
                
                DispatchQueue.main.async {
                    // Optionally notify the user of the error
                    showToast("Failed to add item to cart. Please try again.")
                }
            }
        }
    }
   
    func addToFavouritesAction(at indexPath: IndexPath) {
        guard var category = shoppingCartData.first(where: { $0.name == "Food" }),
              var itemsValue = category.items,
              indexPath.row < itemsValue.count else { return }
        
        // Fetch the item to update
        var item = itemsValue[indexPath.row]
        item.isBookmarked.toggle()
        
        // Update Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", item.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let coreDataItem = results.first {
                coreDataItem.isBookmarked = item.isBookmarked
            }
            
            // Save the context
            try context.save()
            fetchAndPrintCategories(context: context)
            
            // Update the local data source
            itemsValue[indexPath.row] = item
            category.items = itemsValue
            shoppingCartData.removeAll(where: { $0.name == "Food" })
            shoppingCartData.append(category)
                    
            // Update the UI
            if let cell = monuCollectionView.cellForItem(at: indexPath) as? shoppingCartCollectionCell {
                cell.configure(with: item, indexPath: indexPath)
                showToast(cell.addFavouriteButton.isSelected ? "Added to favourites" : "Removed from favourites")
            }
        } catch {
            print("Failed to fetch or save item: \(error.localizedDescription)")
        }
    }
    
    func fetchAndPrintCategories(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {                
                if let items = category.relationship as? Set<Item> {
                    for item in items {
                        print("  Item: \(item.name ?? "Unknown") - Price: \(item.price) ==> isAdded ToCart  \(item.isAddedToCart)")
                    }
                }
            }
        } catch {
            print("Failed to fetch categories: \(error)")
        }
    }

//    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
//        // Create a URLSession data task
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            // Check for errors
//            if let error = error {
//                print("Error fetching image: \(error)")
//                completion(nil)
//                return
//            }
//            
//            // Check if data was received
//            guard let data = data else {
//                print("No data received")
//                completion(nil)
//                return
//            }
//            
//            // Convert data to UIImage
//            let image = UIImage(data: data)
//            // Call completion handler on the main thread
//            DispatchQueue.main.async {
//                completion(image)
//            }
//        }
//        
//        // Start the data task
//        task.resume()
//    }

    
   
}
