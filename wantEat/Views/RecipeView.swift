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
    @State var networkManager = NetworkManager()
    @Environment(\.managedObjectContext) var moc
    let searchedResults:[ResponceItem] = [
        ResponceItem(id: 0, name: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",imageUrl: "lunch", stars: 4, healthy: 19.0, likes: 300,matchedIngredients: ["apple","pork","bread"], vegan: true, category: ["lunch","lunch main","course main", "dish dinner"],cookingTime: 45,allIngredients: ["Avocado","Cauliflower","Broccoli","Purple potato","Cheese"],stepsDescription: "1 Step 2 Step",calories: 523.5, carbs: 65, fat: 0.2, protein: 16)
    ]
    @State var test:[Receipe] = [Receipe(name: "1", image: ""),Receipe(name: "12", image: "")]
    
    
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
                print(self.items)
            }
            .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
            List(test, id: \.self){res in
                Text(res.name)
                
            }
            
            Button(action:{self.networkManager.fetch(matching: "potato")
                self.test.append(contentsOf: self.networkManager.receipes)
                print(self.test)
            }){
                Text("TEST")
                    .foregroundColor(Color.black)
                    .frame(width: 28, height: 6)
                    .background(Color.red)
                
            }
        }.onAppear(perform: { self.fetchCoreDataAsArray() } )
        
    }
    func fetchCoreDataAsArray(){
        items = Array(sItems.map { IngredientChipModel(name: $0.name!, wasBought: $0.wasBought, measure: $0.measure,quantity: $0.quantity) })
    }
    func addIngredient(){
        //arr.append( IngredientChipModel(name: inputField))
        
        items.append(IngredientChipModel(name: self.inputField, wasBought: true, measure: "",quantity: 0))
        
        
        
        self.inputField = ""
        print(items)
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
    //    func changeShoppingItem(shoppingWish: ShoppingWish){
    //
    //        shoppingWish.useForSearch.toggle()
    //        if self.moc.hasChanges{
    //            try? self.moc.save()
    //
    //        }
    //
    //    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}

