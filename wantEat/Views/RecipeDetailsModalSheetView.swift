//
//  RecipeDetailsModalSheetView.swift
//  wantEat
//
//  Created by Vlad Svyryd on 22.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct RecipeDetailsModalSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    let recipe: ResponceItem
    var body: some View{
        VStack(alignment: .center){
            ZStack(alignment: .bottomTrailing){
                Image(recipe.image).resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width, height: 225).clipped()
                HStack(spacing: 0.0){Text("vegan").foregroundColor(Color(.darkGray)).padding(.vertical, 2).padding(.horizontal,10)
                    
                }.background(Color(.yellow)).offset(x: 0, y: -25)
                HStack{
                    WhiteChip(iconName: "star", text: String(format: "%.1f",recipe.spoonacularScore))
                    WhiteChip(iconName: "healthy", text: String(format: "%.1f",recipe.healthScore))
                    
                }.offset(x: -45, y: 12)
                
                
            }
            VStack(spacing: 12.0){
                Text(recipe.title)
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                HStack{
                    ForEach(recipe.dishTypes, id: \.self){
                        cat in
                        
                        Text(cat)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                            .padding(.vertical, 4)
                            
                            .padding(.horizontal,9)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray, lineWidth: 2)
                        )
                        
                        
                        
                    }
                }
                HStack(alignment: .top, spacing: 8.0){
                    Image("stopwatch").resizable().frame(width:26, height :26)
                    Text("Cooking time: \(String(recipe.spoonacularScore)) min.")
                        .fontWeight(.semibold)
                    Spacer()
                }
//                HStack{
//                    ForEach(recipe.usedIngredients, id: \.self){
//                        cat in
//                        
//                        Text(cat)
//                            .fontWeight(.bold)
//                            .lineLimit(nil)
//                            .padding(.vertical, 4)
//                            .padding(.horizontal,9)
//                        
//                        
//                        
//                        
//                    }
//                }
                VStack(alignment: .leading){
                    Text("description")
                   
                }
//                HStack(spacing: 11.0){
//                    MeasureUnit(measureName: "Calories",color: .red)
//                    MeasureUnit(measureName: "Carbs",color: .blue)
//                    MeasureUnit(measureName: "Fat",color: .orange)
//                    MeasureUnit(measureName: "Protein",color: .white)
//                }
                
            }.padding(.horizontal,40).padding(.top,35).frame(width: UIScreen.main.bounds.width).background(Color(.white))
            Spacer()
            
            Button("Dismiss"){
                self.presentationMode.wrappedValue.dismiss()
            }
            Spacer()
        }.edgesIgnoringSafeArea(.all)
        
    }
}

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

struct WhiteChip: View {
    let iconName: String
    let text: String
    var body: some View{
        HStack{
            IconWithLabel(iconName: iconName, labelName: text).padding(.vertical, 3).padding(.horizontal,10)
            
        }.background(Color(.white)).cornerRadius(16).shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(1))
    }
    
}
struct Flagy: View{
    
    var body: some View {
        
        
        Path { path in
            path.move(to:CGPoint(x: 0,y: 3))
            path.addLine(to:CGPoint(x: 85, y: 3))
            path.addLine(to:CGPoint(x: 85, y: 0))
            path.addLine(to:CGPoint(x: 0, y: 0))
        }.fill(Color.init(red: 0, green: 0, blue: 0, opacity: 0.85))
        
        
    }
    
}
//struct RecipeDetailsModalSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeDetailsModalSheetView(recipe: ResponceItem(id: 0, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "lunch", spoonacularScore: 4, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45,usedIngredients: ["Avocado","Cauliflower","Broccoli","Purple potato","Cheese"]))
//    }
//}
