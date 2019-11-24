//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI


struct RecipeView: View {
    
    
    let searchedResults:[ResponceItem] = [
        ResponceItem(id: 0, name: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",imageUrl: "lunch", stars: 4, healthy: 19.0, likes: 300,matchedIngredients: ["apple","pork","bread"], vegan: true, category: ["lunch","lunch main","course main", "dish dinner"],cookingTime: 45,allIngredients: ["Avocado","Cauliflower","Broccoli","Purple potato","Cheese"],stepsDescription: "1 Step 2 Step",calories: 523.5, carbs: 65, fat: 0.2, protein: 16)
       ]
    
    var body: some View {
        VStack(alignment: .leading){
            List(searchedResults){res in
                SearchResult(res: res).padding(.vertical, 2)
                
            }.onAppear { UITableView.appearance().separatorStyle = .none }
                .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
        }
        
    }
}

struct SearchResult: View {
    let res: ResponceItem
    @State private var showRecepieDetailsSheet = false
    var body: some View{
        
        
        
        
        
        HStack(alignment: .top){
            
            Image(res.imageUrl)
                .padding(.bottom)
                .frame(width: 110, height: 95)
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
            
            
            
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    Text("\(res.name)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                }
                
                
                HStack(alignment: .bottom){
                    
                    IconWithLabel(iconName: "star", labelName: String(format: "%.1f",res.stars))
                    IconWithLabel(iconName: "healthy", labelName: String(format: "%.1f",res.healthy))
                    IconWithLabel(iconName: "like", labelName: String(res.likes))
                }
                HStack(alignment: .bottom){
                    ForEach(res.matchedIngredients,id : \.self){
                        chip in
                        MatchChip(match: chip)
                    }
                    
                }
                
            }.padding(.horizontal, 7).frame(height:95)
            Spacer()
        }.frame(height: 150)
            .padding(.vertical, -7)
            .padding(.horizontal, 7)
            .background(Color.white)
            .cornerRadius(15)
            .shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(3))
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        self.showRecepieDetailsSheet.toggle()
                }
        )
            .sheet(isPresented: $showRecepieDetailsSheet) {
                RecipeDetailsModalSheetView(recipe: self.res)
                
        }
    }
}

struct IconWithLabel: View{
    let iconName: String
    let labelName: String
    var body: some View{
        HStack(spacing: 5.0){
            Image(iconName).resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
            Text(labelName).font(.footnote).fontWeight(.medium)
        }
    }
}

// chip of products that user has for recipe
struct MatchChip: View{
    let match: String
    var body: some View{
        Text("\(match)").font(.callout).fontWeight(.medium).padding([.leading, .trailing],7).padding(.bottom, 2).background(Color.green).cornerRadius(10)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}
