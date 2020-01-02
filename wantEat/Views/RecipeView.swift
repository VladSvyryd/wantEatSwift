//
//  SwiftUIView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import WaterfallGrid
//import SwiftUIExtensions
//import QGrid
import CoreData
//import Foundation

struct RecipeView: View {
    // Service instance to comunicate with API
    @State var networkManager = NetworkManager()
    // instance of CoreData to save/delete/update CoreData
    @Environment(\.managedObjectContext) var moc
    @State var searchedResults:[ResponceItem] = [
        ResponceItem(id: 0, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "https://www.energie-tipp.de/wp-content/uploads/uploads/2018/12/6995578-image.jpg", spoonacularScore: 78.0, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45,usedIngredients: [], analyzedInstructions: [])
    ]
    
    
    
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: [NSSortDescriptor(key: "dateWasBought", ascending: false)]) var sItems: FetchedResults<ShoppingWish>
    
    @State var inputField = ""
    
    @State var items = [IngredientChipModel]()
    @State var rectArray = [TagModel(index: 1), TagModel(index: 2),TagModel(index: 3),TagModel(index: 4),TagModel(index: 5),TagModel(index: 6),TagModel(index: 7),TagModel(index: 8)]
    var body: some View {
        
        VStack{
            VStack{
                VStack{
                    VStack(alignment: .leading){
                        
                        WaterfallGrid(self.items, id: \.self.id) { chip in
                            
                            chip.wasBought ?
                                IngredientChip(chip: chip, chipsArray: self.$items)
                                : nil
                            
                            
                        }.gridStyle(
                            columns: 3, spacing: 2,
                            padding: EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
                        )
                        
                    }
                    .frame(height: 122)
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
                    let inputAsArray = self.items.map{ "\($0.name.lowercased())" }
                    let inputAsString = inputAsArray.joined(separator:",")
                    print(inputAsString)
                    self.networkManager.fetchRecipes(stringQueryOfIngredients: inputAsString , numberOfResults: 10){
                        self.searchedResults = $0.results
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
        
        items.insert(IngredientChipModel(name: self.inputField, wasBought: true, measure: "",quantity: 0),at: 0)
        self.inputField = ""
        
    }
}

struct SearchResult: View {
    let res: ResponceItem
    @State private var showRecepieDetailsSheet = false
    @State var scaleFactor: Double = 0
    var body: some View{
        HStack(alignment: .top){
            
            URLImage(url: res.image)
                
                .scaleEffect(1.35)
                .padding(.bottom)
                .frame(width: 110, height: 95)
                .cornerRadius(10)
                .opacity(scaleFactor)
                .onAppear(){
                    withAnimation {
                        self.scaleFactor = 1.0
                    }
            }
            
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    Text("\(res.title)")
                        
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2).fixedSize(horizontal: false, vertical: true)
                }
                Spacer().layoutPriority(0)
                HStack(alignment: .bottom){
                    
                    IconWithLabel(iconName: "star", labelName: String(format: "%.1f",res.spoonacularScore / 20))
                    IconWithLabel(iconName: "healthy", labelName: String(format: "%.1f",res.healthScore))
                    IconWithLabel(iconName: "like", labelName: String(res.likes))
                }
                HStack(alignment: .bottom){
                    ForEach(res.usedIngredients.shuffled()){
                        MatchChip(match: $0)
                    }
                    //Text("here are matched ingredients")
                }
                
            }.padding(.horizontal, 7).frame(height:95)
            Spacer()
        }.frame(height: 150).animation(.spring())
            
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
    let match: ResponceItem.UsedIngredient
    var body: some View{
        Text("\(match.name)")
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
        
        ZStack{
            Rectangle()
                .foregroundColor(Color.init(red: 224 / 255, green: 224 / 255, blue: 224 / 255, opacity: 1.0))
                .frame( height: chip.name.count  > 7 ? CGFloat(chip.name.count / 2  * 10) : 30)
                    .cornerRadius(15)
                    
                    HStack{
                        Text("\(chip.name )")
                            .font(.callout)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            //.fixedSize(horizontal: true, vertical: false)
                        Spacer()
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
                    }.padding(.horizontal, 10)
            
            
            
        }
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

