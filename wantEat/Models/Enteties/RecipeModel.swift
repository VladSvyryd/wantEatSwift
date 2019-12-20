//
//  ResponceItem.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import CoreData

struct ResponceResult:Codable & Hashable{
    let results: [ResponceItem]
}

struct ResponceItem: Identifiable, Codable ,  Hashable{
    let id: Int
    let title: String
    let image: String
    let spoonacularScore: Double
    let healthScore: Double
    let likes: Int
    //let matchedIngredients: [String]
    let vegan: Bool
    let dishTypes: [String]
    let readyInMinutes: Double
    //let usedIngredients: [String]
    //let analyzedInstructions: String
    //let calories: Double
    //let carbs: Double
    //let fat: Double
    //let protein: Double
    
//    private enum CodingKeys: String, CodingKey {
//           case success = "success"
//           case timestamp = "timestamp"
//           case base = "base"
//           case date = "date"
//           case rates = "rates"
//       }
}

struct IngredientChipModel: Identifiable{
    let id = UUID()
    let name: String
    let wasBought: Bool
    let measure: String?
    let quantity: Double?
}
extension IngredientChipModel: Equatable {
    static func == (lhs: IngredientChipModel, rhs: IngredientChipModel) -> Bool {
        return
            lhs.id == rhs.id 
    }
}
