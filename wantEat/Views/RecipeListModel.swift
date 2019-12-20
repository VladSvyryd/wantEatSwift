//
//  RecipeListModel.swift
//  wantEat
//
//  Created by Vlad Svyryd on 20.12.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

//final class RecipeListModel: ObservableObject{
//    var stringQueryOfIngredients: String
//    var numberOfResults: Int
//    init(){
//        fetchRecipes(query: stringQueryOfIngredients, numberOfResults: numberOfResults)
//    }
//    var result : ResponceResult
//    private func fetchRecipes(query: String,numberOfResults : Int ){
//        NetworkManager().fetchRecipes(stringQueryOfIngredients: query, numberOfResults: numberOfResults) {
//            self.result = $0
//        }
//    }
//    let didChange = PassthroughSubject<RecipeListModel, Never>()
//}
