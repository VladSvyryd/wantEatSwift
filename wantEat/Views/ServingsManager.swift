//
//  ServingsManager.swift
//  wantEat
//
//  Created by Vlad Svyryd on 28.01.20.
//  Copyright © 2020 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation

class ServingsManager {
    func setNewIngredients(ingredients:[Recipe.UsedIngredient],standardServingAmount:Int ,factor: Int) -> [Recipe.UsedIngredient]{
        let newIngredients:[Recipe.UsedIngredient] = ingredients.map {
            let forOne = $0.amount / Double(standardServingAmount)
           return Recipe.UsedIngredient(id: $0.id, amount: forOne * Double(factor), unit: $0.unit, name: $0.name, originalString: $0.originalString, imageUrl: $0.imageUrl) }
        return newIngredients
    }

}
