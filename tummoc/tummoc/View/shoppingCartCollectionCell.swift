//
//  shoppingCartCollectionCell.swift
//  tummoc
//
//  Created by nav on 25/07/24.
//

import Foundation
import UIKit

class shoppingCartCollectionCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addFavouriteButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.red), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var addToFavourtiesCallBack: ((IndexPath) -> Void)?
    
    var addingToCartCallBack: ((IndexPath) -> Void)?

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Helper method to set up UI components
    private func setupUI() {
        // Add subviews
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(productNameLabel)
        cardView.addSubview(priceLabel)
        cardView.addSubview(addToCartButton)
        cardView.addSubview(addFavouriteButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            thumbnailImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 25),
            thumbnailImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            thumbnailImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            thumbnailImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.55),
            
            productNameLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 5),
            productNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -2),
            
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: -2),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -1),

            addToCartButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            addToCartButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            addToCartButton.widthAnchor.constraint(equalToConstant: 40),
            
            addFavouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            addFavouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            addFavouriteButton.heightAnchor.constraint(equalToConstant: 50),
            addFavouriteButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        addFavouriteButton.addTarget(self, action: #selector(addFavouriteButtonTapped), for: .touchUpInside)
        
        addToCartButton.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)

    }

    @objc func addFavouriteButtonTapped() {
        guard let indexPath = indexPath else { return }
        addToFavourtiesCallBack?(indexPath)
    }
    
    @objc func addToCartAction() {
        guard let indexPath = indexPath else { return }
        addingToCartCallBack?(indexPath)
    }
    
    func configure(with item: ItemData, indexPath: IndexPath) {
        self.indexPath = indexPath
        addFavouriteButton.isSelected = item.isBookmarked
        let imageName = item.isBookmarked ? "heart.fill" : "heart"
        addFavouriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
