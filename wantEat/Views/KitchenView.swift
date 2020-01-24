//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import Foundation
import Combine
import URLImage

struct RandomRecipe: Identifiable{
    var id: Int?
    let title, imageUrl: String
    let ingredients: [String]
}

struct KitchenView: View {
    let categories:[RandomRecipe] = [
        RandomRecipe(id: 0, title: "Schaschlik", imageUrl: "breakfast", ingredients:["Pork", "garlic", "catchup", "butter"]),
        RandomRecipe(id: 1, title: "Steak", imageUrl: "lunch",ingredients:["Pork", "parsley", "thyme", "rosemary"]),
        RandomRecipe(id: 2, title: "test", imageUrl: "dinner",ingredients:["Pork", "thyme", "catchup", "butter"]),
        RandomRecipe(id: 3, title: "Cake", imageUrl: "dessert",ingredients:["Pork", "rosemary", "catchup" ,"butter"])
    ]
    let mealCategories:[String] = ["breakfast","lunch","dinner","dessert"]
    
    @State var activeScrollView: Int = 2
    @State var activeButton = 0
    @State var searchedRandomResults:[RandomRecipeResult.RecipeInformation] = [RandomRecipeResult.RecipeInformation(id: 1, title: "Stake", image: "https://spoonacular.com/recipeImages/830601-556x370.jpg", servings: 2, readyInMinutes: 60, aggregateLikes: 500, healthScore: 45.6, spoonacularScore: 32.3, analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Place a large skillet over medium heat.",ingredients: [Recipe.Ingredient(id: 1, name: "bread")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Mix the ground beef with the garlic powder, onion powder, parsley flakes, salt and pepper.",ingredients: [Recipe.Ingredient(id: 111, name: "salt and pepper"),Recipe.Ingredient(id: 222, name: "dried parsley"),Recipe.Ingredient(id: 333, name: "garlic powder"),Recipe.Ingredient(id: 444, name: "onion powder")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 3, step: "Roll the beef mixture into 1-inch round meatballs.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 4, step: "Add 1 tablespoon of olive oil to the skillet.",ingredients: [Recipe.Ingredient(id: 1, name: "olive oil")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 5, step: "Place the meatballs in the skillet (cook in twobatches if they won't all fit) and cook the meatballs completely, turning to brown on each sideevery 3-4 minutes. Once the meatballs are cooked through, remove them from the pan and setaside.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 6, step: "Toss the diced onion into the skillet. Cook the onion for 4-5 minutes, until it's beginning tosoften, stirring frequently.",ingredients: [Recipe.Ingredient(id: 1, name: "onion")], length: Recipe.TimeLength(number: 4, unit: "min")),])], vegan: true, dishTypes: ["dinner"], extendedIngredients: [RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: "pork", id: 2341, consitency: "solid", amount: 23.5, unit: "kg"),RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: "garlic", id: 341, consitency: "solid", amount: 1.5, unit: "kg")])]
    var networkManager = NetworkManager()
    var body: some View {
        
        VStack(spacing: 20){
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center){
                    ForEach(searchedRandomResults) { randomRecipe in
                        GeometryReader{ geometry in
                            BoxView(randomRecipe: randomRecipe)
                                .rotation3DEffect(Angle(degrees:(Double(geometry.frame(in: .global).minX) - (Double(UIScreen.main.bounds.width / 4))) / -5), axis: (x:0, y:10.0 , z:0))
                        }
                        .frame(width: 200, height: 300)
                    }
                }
                .padding(.top,35)
                .padding(.bottom,35)
                .padding(.leading, UIScreen.main.bounds.width / CGFloat(UIScreen.main.bounds.width / 110))
                .padding(.trailing,  UIScreen.main.bounds.width / CGFloat(UIScreen.main.bounds.width / 110))
            }
            HStack(alignment: .top){
                ForEach(0..<mealCategories.count){  i in
                    Button(action:{
                        self.activeButton = i
                    }){
                        Text("\(self.mealCategories[i])")
                    }
                    
                }
            }
            HStack(alignment: .center){
                Text("Popular")
                    .font(.headline)
                Spacer()
                Button(action:{
                    
                }){
                    Image("dots").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color.black)
                        .frame(width: 28, height: 6).onTapGesture {
                            
                            self.networkManager.fetchRandomRecipes(stringQueryOfTags: "salad" , numberOfResults: 5) {
                                           let randomRecipes = $0.recipes
                                           if(randomRecipes.isEmpty){
                                               print("empty")
                                           }else{
                                               self.searchedRandomResults = randomRecipes
                                           }
                                  }
                    }
                    
                }
                
            }.padding(.horizontal,40)
            VStack(spacing: 20){
                HugeButton(image: Image("tomatoes"), name: "salad")
                   
                HugeButton(image: Image("soup"), name: "soup")
                HugeButton(image: Image("dips"), name: "sauce")
            }
            Spacer()
        }
    }
}

struct HugeButton: View{
    var image: Image
    var name: String
    
    @State var clicked = false
    var body: some View {
        Button(action:{
            //self.clicked.toggle()
           
          
        }){
            ZStack{
                image.renderingMode(.original).resizable().aspectRatio(1,contentMode: .fill).scaleEffect(1).frame(width: UIScreen.main.bounds.width - 100, height: 70).cornerRadius(20).blendMode(.screen)
                    .overlay(
                        !clicked ?  Rectangle().foregroundColor(Color.init(hue: 0.5, saturation: 0, brightness: 0, opacity: 0.25)).cornerRadius(20) : nil
                );   Text(name).foregroundColor(!clicked ?  Color.white: Color .black).fontWeight(.semibold).padding(.horizontal,5).cornerRadius(10)
                
            }.shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(3))
            
            
        }
        
    }
    
}

struct BoxView: View{
    let randomRecipe: RandomRecipeResult.RecipeInformation
    var ingredients:String{
        let a = randomRecipe.extendedIngredients.map{String($0.name)}
        return a.joined(separator: ", ")
    }
    var body: some View {
        ZStack(alignment: .bottom){
            
            URLImage(URL(string: randomRecipe.image)!,
                     placeholder: { _ in
                         Image("logo")
                             .resizable()
                              .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 300).cornerRadius(15, corners: [.bottomLeft, .bottomRight]).border(Color.gray, width: 1)
                     }
                     ){
                proxy in
                proxy.image
                    
                 .resizable()
                        .scaledToFill()
                    
                    .frame(width: 200, height: 300)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                        .clipped()
                        .cornerRadius(15, corners: [.topLeft, .topRight])
                    
            }
            
            HStack(alignment: .top){
                
                VStack(alignment: .leading){
                    
                    Text(randomRecipe.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                    
                    
                    HStack{
                        Text(ingredients)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                    }
                    
                }
                
                Spacer()
            }.padding(.leading,15).frame(width: 200, height: 80)
                
                .background(Color.init(red: 0, green: 0, blue: 0, opacity: 0.55))
               
        } .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        KitchenView(searchedRandomResults: [RandomRecipeResult.RecipeInformation(id: 1, title: "Stake", image: "https://spoonacular.com/recipeImages/794066-556x370.jpg", servings: 2, readyInMinutes: 60, aggregateLikes: 500, healthScore: 45.6, spoonacularScore: 32.3, analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Place a large skillet over medium heat.",ingredients: [Recipe.Ingredient(id: 1, name: "bread")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Mix the ground beef with the garlic powder, onion powder, parsley flakes, salt and pepper.",ingredients: [Recipe.Ingredient(id: 111, name: "salt and pepper"),Recipe.Ingredient(id: 222, name: "dried parsley"),Recipe.Ingredient(id: 333, name: "garlic powder"),Recipe.Ingredient(id: 444, name: "onion powder")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 3, step: "Roll the beef mixture into 1-inch round meatballs.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 4, step: "Add 1 tablespoon of olive oil to the skillet.",ingredients: [Recipe.Ingredient(id: 1, name: "olive oil")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 5, step: "Place the meatballs in the skillet (cook in twobatches if they won't all fit) and cook the meatballs completely, turning to brown on each sideevery 3-4 minutes. Once the meatballs are cooked through, remove them from the pan and setaside.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 6, step: "Toss the diced onion into the skillet. Cook the onion for 4-5 minutes, until it's beginning tosoften, stirring frequently.",ingredients: [Recipe.Ingredient(id: 1, name: "onion")], length: Recipe.TimeLength(number: 4, unit: "min"))])], vegan: true, dishTypes: ["dinner"], extendedIngredients: [RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: "pork", id: 2341, consitency: "solid", amount: 23.5, unit: "kg"),RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: "garlic", id: 341, consitency: "solid", amount: 1.5, unit: "kg")])])
    }
}

