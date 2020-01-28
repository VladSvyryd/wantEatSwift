
//
//  RecipeDetailsModalSheetView.swift
//  wantEat
//
//  This struct represents View of Recipe Details
//  Basic functionality:
//        - visualize Recipe Information and it's Instructions
//
//  Created by Vlad Svyryd on 22.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import WaterfallGrid
import URLImage


struct RecipeDetailsModalSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    let recipe: Recipe
    // Service instance to comunicate with API
    @State var networkManager = NetworkManager()
    @State var nutritionIsLoaded = false
    @State var nutritionInformation = Nutrition(calories: "n/a", carbs: "n/a", fat: "n/a", protein: "n/a")
    @State var numberOfPortions = 0
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
                    ScrollView{
                        Text(recipe.title)
                            .font(.system(size: 26))
                            .fontWeight(.bold)
                        HStack{
                            
                            WaterfallGrid(recipe.dishTypes, id: \.self) { type in
                                DishTypeChip(dishType: type)
                            }.gridStyle(
                                columns: 3, spacing: 5,
                                padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
                            )
                        }.frame(height: 54)
                        HStack(alignment: .center, spacing: 8.0){
                            Image("stopwatch").resizable().frame(width:26, height :26)
                            Text("Cooking time: \(String(format: "%.0f",recipe.readyInMinutes)) min.")
                                .fontWeight(.semibold)
                            Spacer()
                            Image("logoSmallicon").resizable().scaledToFit().frame(width:26, height :26)
                            Text("Servings: \(String(recipe.servings))")
                                .fontWeight(.semibold).padding(.trailing, 5)
                            
                        }
                        
                        Rectangle().frame(width: UIScreen.main.bounds.width - 40, height: 1).foregroundColor(Color.gray)
                        HStack{
//                            WaterfallGrid(recipe.usedIngredients + recipe.missedIngredients, id:\.self.id) { ingredient in
//
//                                IngredienTagComplex(ingredient:  ingredient,usedIngredients: self.recipe.usedIngredients, width: 20)
//                            }.gridStyle(
//                                spacing: 8, padding: EdgeInsets(top: 2, leading: 4, bottom: 8, trailing: 4), scrollDirection: .horizontal
//                            )
                            Text("")
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
}
// View of single instruction step
struct InstructionRow: View{
    let instructionStep: Recipe.Step
    @State var instructionIngredientAsString: String
    var body: some View{
        
        HStack(alignment: .top){
            Text("\(instructionStep.number) :").fontWeight(.semibold)
            VStack(alignment: .leading){
                !self.instructionIngredientAsString.isEmpty ?(Text("(\(self.instructionIngredientAsString))").fontWeight(.semibold)) : nil
                Text("\(instructionStep.step)" )
            }
            Spacer()
        }.onAppear{
            let a = self.instructionStep.ingredients.map{String($0.name)}
            self.instructionIngredientAsString = a.joined(separator: ", ")
            
            
        }
        
        
    }
}
// Object to visialise nutrients. (Calories, Carbs, Fat,  Protein)
struct MeasureUnit: View {
    let nutritionNumberFor : String
    let measureName: String
    let color: Color
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width: 75, height: 75).overlay(Circle().stroke(color, lineWidth: 5))
            VStack{
                Text(String(measureName).capitalizingFirstLetter())
                Text(String(nutritionNumberFor))
            }
            
        }.shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(1))
    }
}
// grey text with stroke as type of dish
struct DishFeatureChip: View {
    let iconName: String
    let text: String
    var body: some View{
        HStack{
            IconWithLabel(iconName: iconName, labelName: text).padding(.vertical, 3).padding(.horizontal,10)
            
        }.background(Color(.white)).cornerRadius(16).shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(1))
    }
    
}

// element to show which ingredients and weight needed for recipe
struct IngredienTagComplex: View {
    let ingredient : Recipe.UsedIngredient
    let usedIngredients : [Recipe.UsedIngredient]
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


struct DishTypeChip: View {
    
    let dishType: String
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(Color.white)
                .frame(height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
            )
            HStack{
                Text(dishType)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
                    .padding(.vertical, 3)
                    .padding(.horizontal,3)
            }
        }
    }
    
}
struct Flagy: View{
    //@State var localPosition: (x:CGFloat,y:CGFloat)
    
    var body: some View {
        
        GeometryReader{ geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                path.addLines([
                    CGPoint(x: 0, y:height + 3),
                    CGPoint(x: width / 2.2 , y: height / 2),
                    CGPoint(x: 0 , y: -3),
                    
                    CGPoint(x: width , y: 0),
                    
                    CGPoint(x: width , y: height)
                    
                    
                    
                ])
                
            }.fill(Color(.yellow))
            
        }
        
        
    }
    
}
struct RecipeDetailsModalSheetView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsModalSheetView(recipe: Recipe(id: 551292, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "https://spoonacular.com/recipeImages/551292-312x231.jpg", spoonacularScore: 4.0, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45.0, usedIngredients:[ Recipe.UsedIngredient(id: 1, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 11, amount: 5, unit: "g", name: "potato", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 22, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 33, amount: 5, unit: "g", name: "champinions", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 44, amount: 4, unit: "large", name: "key", originalString: "123", imageUrl: "lunch ")],missedIngredients: [Recipe.UsedIngredient(id: 156, amount: 0.5, unit: "g", name: "TOMATO", originalString: "123", imageUrl: "lunch ")] ,analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Place a large skillet over medium heat.",ingredients: [Recipe.Ingredient(id: 1, name: "bread")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Mix the ground beef with the garlic powder, onion powder, parsley flakes, salt and pepper.",ingredients: [Recipe.Ingredient(id: 111, name: "salt and pepper"),Recipe.Ingredient(id: 222, name: "dried parsley"),Recipe.Ingredient(id: 333, name: "garlic powder"),Recipe.Ingredient(id: 444, name: "onion powder")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 3, step: "Roll the beef mixture into 1-inch round meatballs.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 4, step: "Add 1 tablespoon of olive oil to the skillet.",ingredients: [Recipe.Ingredient(id: 1, name: "olive oil")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 5, step: "Place the meatballs in the skillet (cook in twobatches if they won't all fit) and cook the meatballs completely, turning to brown on each sideevery 3-4 minutes. Once the meatballs are cooked through, remove them from the pan and setaside.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 6, step: "Toss the diced onion into the skillet. Cook the onion for 4-5 minutes, until it's beginning tosoften, stirring frequently.",ingredients: [Recipe.Ingredient(id: 1, name: "onion")], length: Recipe.TimeLength(number: 4, unit: "min"))
            
            
        ])],servings: 2), nutritionInformation: Nutrition(calories: "300", carbs: "23g", fat: "423g", protein: "23g"))
    }
}
