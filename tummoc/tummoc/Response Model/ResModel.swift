//
//  ResModel.swift
//  tummoc
//
//  Created by nav on 25/07/24.
//

import Foundation


// MARK: - ResponseModel
struct ResponseModel: Codable {
    let status: Bool
    let message: String
    let categories: [CategoryData]
}

// MARK: - Category
struct CategoryData: Codable {
    let id: Int
    let name: String
    var items: [ItemData]?
}

// MARK: - Item
struct ItemData: Codable {
    let id: Int
    let name: String
    let icon: String
    let price: Double
    var isBookmarked: Bool
    var isAddedToCart:Bool
}


struct AppendedResponseModel:Codable {
    let status: Bool
    let message:String
    let categoriesData : [CategoryDataValues]
}

struct CategoryDataValues: Codable {
    let id: Int
    let name: String
    let items: [ItemDataValue]
}

struct ItemDataValue: Codable {
    let id: Int
    let name: String
    let icon: String
    let price: Double
    let isBookmarked: Bool
}
