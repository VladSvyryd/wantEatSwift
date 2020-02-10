//
//  RandomRecipeDetails.swift
//  wantEat
//  This view shows details of Random Recipe - it has to be replaced or merged with RecipeDetailsModalSheetView, as it has almost the same functionalty.
//  Created by Vlad Svyryd on 02.02.20.
//  Copyright © 2020 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import WaterfallGrid
import URLImage

struct RandomRecipeDetails: View {
     @Environment(\.presentationMode) var presentationMode
    let recipe: RandomRecipeResult.RecipeInformation
        // Service instance to comunicate with API
        @State var networkManager = NetworkManager()
        @State var servingsManager = ServingsManager()
        @State var nutritionIsLoaded = false
        @State var nutritionInformation = Nutrition(calories: "n/a", carbs: "n/a", fat: "n/a", protein: "n/a")
        @State var numberOfPortions:Int = 0
        @State var servingNumbers:[String] = Array(1...10).map{String($0)}
        var body: some View{
            
            VStack(alignment: .leading){
                
                ZStack(alignment: .top){
                    ZStack(alignment: .bottomTrailing){
                        URLImage(URL(string: recipe.image)!){ proxy in
                            proxy.image
                                
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 255)
                                .clipped()
                        }
                        
                        //                    Rectangle().frame(width: UIScreen.main.bounds.width
                        //                        ,height: 255).foregroundColor(Color.black)
                        
                        recipe.vegan ? ZStack{
                            Flagy().frame(width: 30, height: 30).offset(x: -32)
                            Text("vegan").foregroundColor(Color(.darkGray)).padding(.vertical, 2).padding(.horizontal,10)
                            
                        }.background(Color(.yellow)).offset(x: 0, y: -45) : nil
                        
                    }
                    VStack{
                        ScrollView(showsIndicators: false){
                            Text(recipe.title)
                                .font(.system(size: 26))
                                .fontWeight(.bold)
                            HStack{
                                
                                WaterfallGrid(recipe.dishTypes, id: \.self) { type in
                                    DishTypeChip(dishType: type)
                                }.gridStyle(
                                    columns: 3, spacing: 5,
                                    padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4),
                                    scrollDirection: .horizontal
                                )
                            }.frame(height: 54)
                            HStack(alignment: .center, spacing: 8.0){
                                Image("stopwatch").resizable().frame(width:26, height :26)
                                Text("Cooking time: \(String(format: "%.0f",recipe.readyInMinutes)) min.")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image("logoSmallicon").resizable().scaledToFit().frame(width:26, height :26)
                                Text("Servings: \(String(numberOfPortions))")
                                    .fontWeight(.semibold).padding(.trailing, 5)
                                
                            }
                            HStack{
                                Picker("Numbers", selection: $numberOfPortions) {
                                    Text(self.servingNumbers[0]).tag(1)
                                    Text(self.servingNumbers[1]).tag(2)
                                    Text(self.servingNumbers[2]).tag(3)
                                    Text(self.servingNumbers[3]).tag(4)
                                    Text(self.servingNumbers[4]).tag(5)
                                    Text(self.servingNumbers[5]).tag(6)
                                    Text(self.servingNumbers[6]).tag(7)
                                    Text(self.servingNumbers[7]).tag(8)
                                    Text(self.servingNumbers[8]).tag(9)
                                    Text(self.servingNumbers[9]).tag(10)
                                    
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }.onAppear(){
                                self.numberOfPortions = self.recipe.servings
                            }
                            Rectangle().frame(width: UIScreen.main.bounds.width - 40, height: 1).foregroundColor(Color.gray)
                            HStack{
                                
                                WaterfallGrid(setNewIngredients(ingredients: self.recipe.extendedIngredients,standardServingCount: recipe.servings, factor: numberOfPortions)) { ingredient in
                                    
                                    IngredienTagForRandomRecipe(ingredient:  ingredient,usedIngredients: [], width: 20)
                                }.gridStyle(
                                    spacing: 8, padding: EdgeInsets(top: 2, leading: 4, bottom: 8, trailing: 4), scrollDirection: .horizontal
                                )
                            }.frame(height: 60)
                            
                            VStack(alignment: .leading, spacing: 3){
                                // instructions array could be empty, need to be tested properly, till then by empty show no instruction
                                
                                ForEach(recipe.analyzedInstructions){instructionSet in
                                    ForEach(instructionSet.steps){step in
                                        InstructionRow(instructionStep: step, instructionIngredientAsString: "")
                                        
                                    }                        }
                                
                            }.padding(.horizontal, 4)
                            HStack(spacing: 11.0){
                                MeasureUnit(nutritionNumberFor:nutritionInformation.calories,measureName: "calories",color: .red)
                                MeasureUnit(nutritionNumberFor:nutritionInformation.carbs,measureName: "carbs",color: .blue)
                                MeasureUnit(nutritionNumberFor:nutritionInformation.fat,measureName: "fat",color: .orange)
                                MeasureUnit(nutritionNumberFor:nutritionInformation.protein,measureName: "protein",color: .white)
                                
                            }.padding(.bottom, 60).onAppear{
                                
                                
                                self.networkManager.getNutritionById(id: self.recipe.id) {
                                    print($0)
                                    self.nutritionInformation = $0
                                    
                                }
                            }
                            Spacer()
                        }.frame(height: UIScreen.main.bounds.height - 330)
                        Spacer()
                    }.padding(.horizontal,40)
                        .padding(.top,35)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .background(Color(.white))
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                        .offset(y: 237)
                    
                    HStack{
                        DishFeatureChip(iconName: "star", text: String(format: "%.1f",(recipe.spoonacularScore / 20)))
                        DishFeatureChip(iconName: "healthy", text: String(format: "%.1f",recipe.healthScore))
                        
                    }.offset(x: UIScreen.main.bounds.width - 325, y: 225)
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("Dismiss").foregroundColor(Color.white).padding(10)
                    }
                    .frame(width:UIScreen.main.bounds.width / 2.3)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.red,radius: 2)
                    .offset(y: UIScreen.main.bounds.height - 115)
                    
                }.offset(y:39)
            }.edgesIgnoringSafeArea(.all)
            
        }
        func setNewIngredients(ingredients:[RandomRecipeResult.RecipeInformation.ExtendedIngredients?],standardServingCount:Int ,factor: Int) -> [RandomRecipeResult.RecipeInformation.ExtendedIngredients]{
            guard let ingreds = ingredients as? [RandomRecipeResult.RecipeInformation.ExtendedIngredients] else{
                return []
            }
            return ingreds.map {
               let forOneServing = $0.amount / Double(standardServingCount)
                return RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: $0.name, id: $0.id, consitency: $0.consitency, amount: forOneServing * Double(factor), unit: $0.unit) }
       }

    
}
// element to show which ingredients and weight needed for recipe
struct IngredienTagForRandomRecipe: View {
    let ingredient : RandomRecipeResult.RecipeInformation.ExtendedIngredients
    let usedIngredients : [RandomRecipeResult.RecipeInformation.ExtendedIngredients]
    @State var width: CGFloat
    var ingredientAmount: String {
        let convertiedToString = String("\(ingredient.amount)")
        if(convertiedToString.prefix(1) == "0"){
            return (String(format: "%.1f",ingredient.amount))
        }else{
            return (String(format: "%.0f",ingredient.amount))
        }
    }
    
    var body: some View{
        ZStack(alignment: .leading){
            Rectangle().frame(width: width).foregroundColor(Color.white)
            Text("\(ingredient.name.capitalizingFirstLetter()) \(ingredientAmount) \(ingredient.unit)").fontWeight(.bold).foregroundColor( self.usedIngredients.contains { (element) -> Bool in
                
                if(element.id == ingredient.id) {return true}
                return false
                } ? Color.green : Color.orange)
        }.onAppear(
            perform:{
                self.countWidthOfTag()
                
                
        }
        )
    }
    
    func countWidthOfTag(){
        let ingredientNameWidth = ingredient.name.count
        let amount = String(format: "%.1f", ingredient.amount)
        let unitWidth = ingredient.unit.count
        print(ingredientNameWidth, amount.count, unitWidth)
        width =  CGFloat((ingredientNameWidth * 14) + (amount.count * 5) + (unitWidth * 10) + 5)
    }
}
struct RandomRecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RandomRecipeDetails(recipe: RandomRecipeResult.RecipeInformation(id: 1, title: "Stake", image: "https://spoonacular.com/recipeImages/794066-556x370.jpg", servings: 2, readyInMinutes: 60, aggregateLikes: 500, healthScore: 45.6, spoonacularScore: 32.3, analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Place a large skillet over medium heat.",ingredients: [Recipe.Ingredient(id: 1, name: "bread")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Mix the ground beef with the garlic powder, onion powder, parsley flakes, salt and pepper.",ingredients: [Recipe.Ingredient(id: 111, name: "salt and pepper"),Recipe.Ingredient(id: 222, name: "dried parsley"),Recipe.Ingredient(id: 333, name: "garlic powder"),Recipe.Ingredient(id: 444, name: "onion powder")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 3, step: "Roll the beef mixture into 1-inch round meatballs.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 4, step: "Add 1 tablespoon of olive oil to the skillet.",ingredients: [Recipe.Ingredient(id: 1, name: "olive oil")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 5, step: "Place the meatballs in the skillet (cook in twobatches if they won't all fit) and cook the meatballs completely, turning to brown on each sideevery 3-4 minutes. Once the meatballs are cooked through, remove them from the pan and setaside.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 6, step: "Toss the diced onion into the skillet. Cook the onion for 4-5 minutes, until it's beginning tosoften, stirring frequently.",ingredients: [Recipe.Ingredient(id: 1, name: "onion")], length: Recipe.TimeLength(number: 4, unit: "min"))])], vegan: true, dishTypes: ["dinner"], extendedIngredients: [RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: "pork", id: 2341, consitency: "solid", amount: 23.5, unit: "kg"),RandomRecipeResult.RecipeInformation.ExtendedIngredients(name: "garlic", id: 341, consitency: "solid", amount: 1.5, unit: "kg")]))
    }
}
