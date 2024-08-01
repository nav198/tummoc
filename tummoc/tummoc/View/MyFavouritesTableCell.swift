//
//  MyFavouritesTableCell.swift
//  tummoc
//
//  Created by nav on 26/07/24.
//

import Foundation
import UIKit

class MyFavouritesTableCell: UITableViewCell {

    // UI Components
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "placeHolderAppIconSquare")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let monumnetInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUI() {
        // Add subviews
        contentView.addSubview(cardView)
        cardView.addSubview(thumbnailImageView)
        cardView.addSubview(monumnetInfoView)
        cardView.addSubview(addButton)
        cardView.addSubview(favouriteButton)
        monumnetInfoView.addSubview(titleLabel)
        monumnetInfoView.addSubview(subTitleLabel)
      
        // Setup constraints
        NSLayoutConstraint.activate([
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            thumbnailImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: 0),
            thumbnailImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 70),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 70),

            monumnetInfoView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            monumnetInfoView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -5),
            monumnetInfoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),

            favouriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            favouriteButton.widthAnchor.constraint(equalToConstant: 22),
            favouriteButton.heightAnchor.constraint(equalToConstant: 22),
            favouriteButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            
            addButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            addButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: monumnetInfoView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: monumnetInfoView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: monumnetInfoView.trailingAnchor, constant: 0),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subTitleLabel.leadingAnchor.constraint(equalTo: monumnetInfoView.leadingAnchor, constant: 0),
            subTitleLabel.trailingAnchor.constraint(equalTo: monumnetInfoView.trailingAnchor, constant: 0),
            subTitleLabel.bottomAnchor.constraint(equalTo: monumnetInfoView.bottomAnchor, constant: -5),
            
      

        ])
    }

    // Configure cell with data
    func configure(with title: String, subtitle: String, thumbnailImage: UIImage?) {
        titleLabel.text = title
        subTitleLabel.text = subtitle
        thumbnailImageView.image = thumbnailImage
    }

}
