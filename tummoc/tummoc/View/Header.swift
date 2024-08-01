//
//  Header.swift
//  tummoc
//
//  Created by nav on 25/07/24.
//

import Foundation
import UIKit

class CustomTableHeaderView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightButton1: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemGray), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        backgroundColor = .systemGray5 // Adjust background color as needed
        
        addSubview(headerLabel)
        addSubview(rightButton1)
        
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        
        // Right Button 1 Constraints
        rightButton1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        rightButton1.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        rightButton1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rightButton1.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightButton1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
      
    
    // MARK: - Public Method to Set Header Title
    
    func setTitle(_ title: String) {
        headerLabel.text = title
    }
}
