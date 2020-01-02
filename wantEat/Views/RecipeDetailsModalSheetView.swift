//
//  RecipeDetailsModalSheetView.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct RecipeDetailsModalSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    let recipe: ResponceItem
    var body: some View{
        VStack(alignment: .center){
            ZStack(alignment: .top){
                
                
                ZStack(alignment: .bottomTrailing){
                    //                URLImage(url: recipe.image).frame(width: UIScreen.main.bounds.width, height: 225).clipped()
                    Rectangle().frame(width: UIScreen.main.bounds.width
                        ,height: 255).foregroundColor(Color.black)
                    
                    ZStack{
                        Flagy().frame(width: 30, height: 30).offset(x: -32)
                        Text("vegan").foregroundColor(Color(.darkGray)).padding(.vertical, 2).padding(.horizontal,10)
                        
                    }.background(Color(.yellow)).offset(x: 0, y: -45)
                    
                    
                    
                    
                    
                }
                VStack(spacing: 10.0){
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
                    HStack(alignment: .top, spacing: 8.0){
                        Image("stopwatch").resizable().frame(width:26, height :26)
                        Text("Cooking time: \(String(format: "%.0f",recipe.spoonacularScore)) min.")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    Rectangle().frame(width: UIScreen.main.bounds.width - 40, height: 1).foregroundColor(Color.gray)
                    HStack{
                        
                        WaterfallGrid(recipe.usedIngredients, id: \.self.id) { ingredient in
                            IngredienTagComplex(ingredient:  ingredient,width: 20)
                        }.gridStyle(
                            spacing: 8, padding: EdgeInsets(top: 2, leading: 4, bottom: 8, trailing: 4), scrollDirection: .horizontal
                        )
                    }.frame(height: 60)
                    VStack(alignment: .leading){
                        Text("description")
                        
                    }
                    //                HStack(spacing: 11.0){
                    //                    MeasureUnit(measureName: "Calories",color: .red)
                    //                    MeasureUnit(measureName: "Carbs",color: .blue)
                    //                    MeasureUnit(measureName: "Fat",color: .orange)
                    //                    MeasureUnit(measureName: "Protein",color: .white)
                    //                }
                    Spacer()
                }
                    
                .padding(.horizontal,40).padding(.top,35).frame(width: UIScreen.main.bounds.width).background(Color(.white)).cornerRadius(25, corners: [.topLeft, .topRight])
                    
                    
                .offset(y: 237)
                HStack{
                    DishFeatureChip(iconName: "star", text: String(format: "%.1f",recipe.spoonacularScore))
                    DishFeatureChip(iconName: "healthy", text: String(format: "%.1f",recipe.healthScore))
                    
                }.offset(x: UIScreen.main.bounds.width - 325, y: 225)
                
                Button("Dismiss"){
                    self.presentationMode.wrappedValue.dismiss()
                }.offset(y: UIScreen.main.bounds.height - 100)
            }
        }.edgesIgnoringSafeArea(.all)
        
    }
}

// Object to visialise nutrients. (Calories, Carbs, Fat,  Protein)
struct MeasureUnit: View {
    let measureName: String,
    color: Color
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width: 75, height: 75).overlay(Circle().stroke(color, lineWidth: 5))
            Text(String(measureName))
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
    let ingredient : ResponceItem.UsedIngredient
    @State var width: CGFloat
    var body: some View{
        ZStack(alignment: .leading){
            Rectangle().frame(width: width).foregroundColor(Color.white)
            Text("\(ingredient.name.capitalizingFirstLetter()) \(String(format: "%.1f",ingredient.amount))\(ingredient.unit)").fontWeight(.bold)
        }.onAppear(
            perform:{ self.countWidthOfTag()}
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
                .onAppear {
                    //print(self.localPosition)
            }
        }
        
        
    }
    
}
struct RecipeDetailsModalSheetView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsModalSheetView(recipe: ResponceItem(id: 0, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "dinner", spoonacularScore: 4.0, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45.0, usedIngredients:[ ResponceItem.UsedIngredient(id: 1, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),ResponceItem.UsedIngredient(id: 11, amount: 5, unit: "g", name: "potato", originalString: "123", imageUrl: "lunch "),ResponceItem.UsedIngredient(id: 22, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),ResponceItem.UsedIngredient(id: 33, amount: 5, unit: "g", name: "champinions", originalString: "123", imageUrl: "lunch "),ResponceItem.UsedIngredient(id: 44, amount: 4, unit: "large", name: "key", originalString: "123", imageUrl: "lunch ")], analyzedInstructions: [ResponceItem.AnalyzedInstruction(steps: [ResponceItem.Step(number: 1, step: "sdawdadw", ingredients: [ResponceItem.Ingredient(id: 1, name: "HOHOHO")], length: ResponceItem.TimeLength(number: 4, unit: "min"))]
            
            )]))
    }
}
