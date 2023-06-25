//
//  Models.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import Foundation
import UIKit

// MARK: - Model
struct FoodModel: Decodable {
    let results: [ResultFood]
}

struct ResultFood: Decodable {
    let urls: Urls?
    let description: String?
    var category: String?
   
}

struct Urls: Decodable {
    let regular: String?
}

