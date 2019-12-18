//
//  ResponceItem.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import CoreData

struct ResponceItem: Identifiable{
    let id: Int
    let name: String
    let imageUrl: String
    let stars: Double
    let healthy: Double
    let likes: Int
    let matchedIngredients: [String]
    let vegan: Bool
    let category: [String]
    let cookingTime: Double
    let allIngredients: [String]
    let stepsDescription: String
    let calories: Double
    let carbs: Double
    let fat: Double
    let protein: Double
}

struct IngredientChipModel: Identifiable{
    let id = UUID()
    let name: String
}
extension IngredientChipModel: Equatable {
    static func == (lhs: IngredientChipModel, rhs: IngredientChipModel) -> Bool {
        return
            lhs.id == rhs.id 
    }
}
