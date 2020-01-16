//
//  NetworkManager.swift
//  wantEat
//
//  Created by Vlad Svyryd on 17.12.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//
import SwiftUI
import Foundation
import Combine

class NetworkManager: ObservableObject {
//    var didChange = PassthroughSubject<NetworkManager,Never>()
//    var recipes : ResponceResult = ResponceResult(results:  [ResponceItem(id: 0, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "lunch", spoonacularScore: 4, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45)]){
//        didSet{
//            didChange.send(self)
//        }
//    }
//    init(){
//        guard let url = URL(string: "ttps://api.spoonacular.com/food/ingredients/autocomplete?query=appl&number=5&apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
//            else {return}
//        URLSession.shared.dataTask(with: url){ (data,responce,error) in
//            if let data = data {
//                do{
//                    let res = try JSONDecoder().decode([Recipe].self, from: data)
//                    // do fetch in main thread
//                    DispatchQueue.main.async {
//                        
//                        self.recipes = res
//                        print(self.recipes)
//                    }
//                }catch let error{
//                    print(error)
//                }
//                
//            }
//            
//        
//            
//            
//            print("completed fetching json")
//        }.resume()
        
 //   }
//    func fetch(matching ingredients: String) {
//        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/autocomplete?query=\(ingredients)&number=5&apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
//                  else {return}
//        URLSession.shared.dataTask(with: url){ (data,responce,error) in
//        if let data = data {
//            do{
//                let res = try JSONDecoder().decode([ResponceItem].self, from: data)
//                // do fetch in main thread
//                DispatchQueue.main.async {
//
//                    self.recipes = res
//                    print(self.recipes)
//                }
//            }catch let error{
//                print(error)
//            }
//
//        }
//    }.resume()
//    }
    func fetchRecipes(stringQueryOfIngredients: String, numberOfResults: Int,diet: String,cuisine: String ,completion: @escaping (ResponceResult) -> ()) {
        print(stringQueryOfIngredients)
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=22a9074551b64e11a4f4ee8bd2f7470f&number=\(numberOfResults)&includeIngredients=\(stringQueryOfIngredients)&instructionsRequired=true&fillIngredients=true&addRecipeInformation=true&ignorePantry=true&cuisine=\(cuisine)&diet=\(diet)")
                  else {return}
        print(url)
        URLSession.shared.dataTask(with: url){ (data,responce,error) in
        if let data = data {
            do{
                let res = try JSONDecoder().decode(ResponceResult.self, from: data)
                // do fetch in main thread
                DispatchQueue.main.async {
                    
                   completion(res)
                }
            }catch let error{
                print(error)
            }
            
        }
    }.resume()
    }
}
