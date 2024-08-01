//
//  SummaryView.swift
//  tummoc
//
//  Created by nav on 28/07/24.
//

import Foundation
import UIKit

class SummaryView: UIView {

    // Small Labels
    let subTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let disCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let subTotalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    let disCountPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    // Large Labels
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    // Horizontal Line
    private let horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Stack Views
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subTotalLabel, subTotalPriceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [disCountLabel, disCountPriceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rowsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, middleStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bigLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, totalPriceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        
        // Add subviews
        addSubview(rowsStackView)
        addSubview(horizontalLine)
        addSubview(bigLabelsStackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Rows Stack View
            rowsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rowsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rowsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            // Horizontal Line
            
            horizontalLine.topAnchor.constraint(equalTo: rowsStackView.bottomAnchor, constant: 10),
            horizontalLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalLine.heightAnchor.constraint(equalToConstant: 2),
            
            // Big Labels Stack View
            bigLabelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bigLabelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bigLabelsStackView.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 16),
            bigLabelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
