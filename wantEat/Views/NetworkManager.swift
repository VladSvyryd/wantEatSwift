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

    func fetchRecipes(stringQueryOfIngredients: String, numberOfResults: Int,diet: String,cuisine: String ,completion: @escaping (ResponceRecipeResult) -> ()) {
        print("stringQueryOfIngredients",stringQueryOfIngredients)
        print("url is: ","https://api.spoonacular.com/recipes/complexSearch?apiKey=22a9074551b64e11a4f4ee8bd2f7470f&number=\(numberOfResults)&includeIngredients=\(stringQueryOfIngredients)&instructionsRequired=true&fillIngredients=true&addRecipeInformation=true&ignorePantry=true&cuisine=\(cuisine)&diet=\(diet)")
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=22a9074551b64e11a4f4ee8bd2f7470f&number=\(numberOfResults)&includeIngredients=\(stringQueryOfIngredients)&instructionsRequired=true&fillIngredients=true&addRecipeInformation=true&ignorePantry=true&cuisine=\(cuisine)&diet=\(diet)")
                  else {return}
     
        URLSession.shared.dataTask(with: url){ (data,responce,error) in
        if let data = data {
            do{
                let res = try JSONDecoder().decode(ResponceRecipeResult.self, from: data)
                // do fetch in main thread
                DispatchQueue.main.async {
                    print("data:", res)
                   completion(res)
                }
            }catch let error{
                print(error)
            }
            
        }
    }.resume()
    }
    
    //stringQueryOfTags - The tags (can be diets, meal types, cuisines, or intolerances) that the recipe must adhere to.
    func fetchRandomRecipes(stringQueryOfTags: String, numberOfResults: Int ,completion: @escaping (RandomRecipeResult) -> ()) {
        
        guard let url = URL(string: "https://api.spoonacular.com/recipes/random?limitLicense=false&tags=\(stringQueryOfTags)&number=\(numberOfResults)&apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
                  else {return}
     
        URLSession.shared.dataTask(with: url){ (data,responce,error) in
        if let data = data {
            do{
                let res = try JSONDecoder().decode(RandomRecipeResult.self, from: data)
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
    
    func getNutritionById (id:Int, completion: @escaping (Nutrition)->()){
        
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(id)/nutritionWidget.json?apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
                      else {return}
         
            URLSession.shared.dataTask(with: url){ (data,responce,error) in
            if let data = data {
                do{
                    let res = try JSONDecoder().decode(Nutrition.self, from: data)
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
