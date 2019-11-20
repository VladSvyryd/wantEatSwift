//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
struct ResponceItem: Identifiable{
    let id: Int
    let name: String
    let imageUrl: String
    let stars: Double
    let healthy: Double
    let likes: Int
    let matchedIngredients: [String]
}

struct RecipeView: View {
    
    
    let searchedResults:[ResponceItem] = [
        ResponceItem(id: 0, name: "Food1 Food1 Food1 Food1 Food1",imageUrl: "lunch", stars: 4, healthy: 19.0, likes: 300,matchedIngredients: ["apple","pork","bread"]),
        ResponceItem(id: 1, name: "Food2",imageUrl: "lunch", stars: 4, healthy: 19.0, likes: 300,matchedIngredients: ["meat","eggs","milk"])]
    
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
                DetailsModalSheet(recepie: self.res)
                
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
struct DetailsModalSheet: View{
    @Environment(\.presentationMode) var presentationMode
    let recepie: ResponceItem
    var body: some View{
        VStack{
            Text(recepie.name)
            Button("Dismiss"){
                self.presentationMode.wrappedValue.dismiss()
            }}
    }
}
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
