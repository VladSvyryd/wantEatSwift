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
    var didChange = PassthroughSubject<NetworkManager,Never>()
    var receipes = [Receipe](){
        didSet{
            didChange.send(self)
        }
    }
    init(){
        guard let url = URL(string: "ttps://api.spoonacular.com/food/ingredients/autocomplete?query=appl&number=5&apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
            else {return}
        URLSession.shared.dataTask(with: url){ (data,responce,error) in
            if let data = data {
                do{
                    let res = try JSONDecoder().decode([Receipe].self, from: data)
                    // do fetch in main thread
                    DispatchQueue.main.async {
                        
                        self.receipes = res
                        print(self.receipes)
                    }
                }catch let error{
                    print(error)
                }
                
            }
            
            //guard let data = data else{ return }
            //let recepies = try! JSONDecoder().decode([Receipe].self, from: data)
            
            //DispatchQueue.main.async {
            //  print(recepies)
            // self.receipes = recepies
            //}
            
            
            print("completed fetching json")
        }.resume()
        
    }
    func fetch(matching ingredients: String) {
        guard let url = URL(string: "https://api.spoonacular.com/food/ingredients/autocomplete?query=\(ingredients)&number=5&apiKey=22a9074551b64e11a4f4ee8bd2f7470f")
                  else {return}
        URLSession.shared.dataTask(with: url){ (data,responce,error) in
        if let data = data {
            do{
                let res = try JSONDecoder().decode([Receipe].self, from: data)
                // do fetch in main thread
                DispatchQueue.main.async {
                    
                    self.receipes = res
                    print(self.receipes)
                }
            }catch let error{
                print(error)
            }
            
        }
    }.resume()
    }
}
