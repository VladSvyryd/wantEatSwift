//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import WaterfallGrid
import SwiftUIExtensions
import QGrid
import CoreData

struct RecipeView: View {
    // Service instance to comunicate with API
    @State var networkManager = NetworkManager()
    // instance of CoreData to save/delete/update CoreData
    @Environment(\.managedObjectContext) var moc
    @State var searchedResults:[ResponceItem] = [
        ResponceItem(id: 0, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "lunch", spoonacularScore: 4, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45)
    ]
    
    
    
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: [NSSortDescriptor(key: "dateWasBought", ascending: false)]) var sItems: FetchedResults<ShoppingWish>
    
    @State var inputField = ""
    
    @State var items = [IngredientChipModel]()
    
    var body: some View {
        
        VStack(alignment: .leading){
            VStack{
                VStack{
                    VStack(alignment: .leading){
                        
                        WaterfallGrid(self.items, id: \.self.id) { chip in
                            
                            chip.wasBought ?
                                IngredientChip(chip: chip, chipsArray:self.$items)
                                : nil
                            
                            
                        }.gridStyle(columnsInPortrait: 3, spacing: 8,animation: Animation.spring())}
                        .frame(height: 200)
                    TextField("Add ingredients", text: self.$inputField ,onCommit: addIngredient)
                        .modifier( ClearButton(text: self.$inputField))
                }
                
                Group{
                    Rectangle()
                        .frame(height: 1, alignment: .bottom)
                        .foregroundColor(Color.secondary)
                }
                
            }.padding(.horizontal)
            List(searchedResults){res in
                SearchResult(res: res)
                    .padding(.vertical, 2)
                
            }
            .onAppear { UITableView.appearance().separatorStyle = .none
                
            }
            .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
            
            
            
            HStack{
                Spacer()
                Button(action: {
                    print("button clicked")
                    self.networkManager.fetchRecipes(stringQueryOfIngredients: "muschrooms,meat", numberOfResults: 1){
                        self.searchedResults.append($0.results[0])
                    }
                 
                }) {
                    Text("Filter").foregroundColor(Color.white).padding(5)
                }.frame(width:UIScreen.main.bounds.width / 2.3)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.green,radius: 5)
                
                Spacer()
            }.padding(.vertical , 10)
        }.onAppear(perform: { self.fetchCoreDataAsArray() } )
        
    }
    // map an array with type IngredientChipModel
    func fetchCoreDataAsArray(){
        items = Array(sItems.map { IngredientChipModel(name: $0.name!, wasBought: $0.wasBought, measure: $0.measure,quantity: $0.quantity) })
    }
    func addIngredient(){
        //arr.append( IngredientChipModel(name: inputField))
        
        items.append(IngredientChipModel(name: self.inputField, wasBought: true, measure: "",quantity: 0))
        self.inputField = ""
        
    }
}

struct SearchResult: View {
    let res: ResponceItem
    @State private var showRecepieDetailsSheet = false
    var body: some View{
        HStack(alignment: .top){
            
            Image(res.image)
                .padding(.bottom)
                .frame(width: 110, height: 95)
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    Text("\(res.title)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                }
                HStack(alignment: .bottom){
                    
                    IconWithLabel(iconName: "star", labelName: String(format: "%.1f",res.spoonacularScore))
                    IconWithLabel(iconName: "healthy", labelName: String(format: "%.1f",res.healthScore))
                    IconWithLabel(iconName: "like", labelName: String(res.likes))
                }
                HStack(alignment: .bottom){
//                    ForEach(res.matchedIngredients,id : \.self){
//                        chip in
//                        MatchChip(match: chip)
//                    }
                    Text("here are matched ingredients")
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
//            .sheet(isPresented: $showRecepieDetailsSheet) {
//                RecipeDetailsModalSheetView(recipe: self.res)
//                
//        }
    }
}

struct IconWithLabel: View{
    let iconName: String
    let labelName: String
    var body: some View{
        HStack(spacing: 5.0){
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            Text(labelName).font(.footnote)
                .fontWeight(.medium)
        }
    }
}

// chip of products that user has for recipe
struct MatchChip: View{
    let match: String
    var body: some View{
        Text("\(match)")
            .font(.callout)
            .fontWeight(.medium)
            .padding([.leading, .trailing],7)
            .padding(.bottom, 2)
            .background(Color.green)
            .cornerRadius(10)
    }
}

struct IngredientChip: View{
    let chip: IngredientChipModel
    @Binding var chipsArray:[IngredientChipModel]
    var body: some View{
        VStack{
            HStack{
                Text("\(chip.name )")
                    .font(.callout)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                
                Button(action: {
                    print("push")
                    self.delete(chip: self.chip)
                }){
                    Text("+")
                        .font(.title)
                        .fontWeight(.thin)
                        .foregroundColor(Color.black)
                        .rotationEffect(Angle(degrees: 45.0))
                    
                }
            }.padding([.leading, .trailing],10)
        }
        .background(Color.init(red: 224 / 255, green: 224 / 255, blue: 224 / 255, opacity: 1.0))
        .cornerRadius(25)
    }
    func delete(chip: IngredientChipModel){
        for element in chipsArray {
            if(chip.id == element.id){
                guard let index = chipsArray.firstIndex(of: element) else { return }
                print(index)
                chipsArray.remove(at: index)
            }
            
        }
    }
    
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}

