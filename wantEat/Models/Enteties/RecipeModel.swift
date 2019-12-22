//
//  ResponceItem.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import CoreData

struct ResponceResult:Codable{
    let results: [ResponceItem]
}

struct ResponceItem: Identifiable, Codable{

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
    let usedIngredients: [UsedIngredient]
    let analyzedInstructions: [AnalyzedInstruction]
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
    struct UsedIngredient: Codable, Identifiable {
        let id: Int
        let amount: Double
        let unit: String
        let name: String
        let originalString: String
        let imageUrl: String
        private enum CodingKeys: String, CodingKey {
            case id
            case amount
            case unit
            case name
            case originalString
            case imageUrl = "image"
        }
        
    }
    struct AnalyzedInstruction: Codable, Identifiable {
        let id = UUID()
        let steps: [Step]
        
    }
    struct Step:Codable, Identifiable{
        let id = UUID()
        let number: Int
        let step: String
        let ingredients: [Ingredient]
        let length: TimeLength?
    }
    struct Ingredient: Codable,Identifiable{
        let id: Int
        let name: String
    }
    struct TimeLength: Codable{
        let number: Int
        let unit: String
        
    }
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
