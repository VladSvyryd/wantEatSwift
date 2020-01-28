//
//  SwiftUIView.swift
//  wantEat
//
//  This struct represents View of Recipe Search
//  Basic functionality:
//        - get list of ingredients that user already has
//        - add external Ingredients
//        - switch search state (personal or general search)
//        - show Recipes shortcuts
//        - open Recipe Information in extra View
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import WaterfallGrid

import URLImage
import CoreData


struct RecipeView: View {
    // Service instance to comunicate with API
    @State var networkManager = NetworkManager()
    // instance of CoreData to save/delete/update CoreData
    @Environment(\.managedObjectContext) var moc
    @State var searchedResults:[Recipe] = [
        Recipe(id: 551292, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "https://scx1.b-cdn.net/csz/news/800/2019/nasamoonrock.jpg", spoonacularScore: 4.0, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45.0, usedIngredients:[ Recipe.UsedIngredient(id: 1, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 11, amount: 5, unit: "g", name: "potato", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 22, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 33, amount: 5, unit: "g", name: "champinions", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 44, amount: 4, unit: "large", name: "key", originalString: "123", imageUrl: "lunch ")],missedIngredients: [Recipe.UsedIngredient(id: 156, amount: 0.5, unit: "g", name: "TOMATO", originalString: "123", imageUrl: "lunch ")],analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Place a large skillet over medium heat.",ingredients: [Recipe.Ingredient(id: 1, name: "bread")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Mix the ground beef with the garlic powder, onion powder, parsley flakes, salt and pepper.",ingredients: [Recipe.Ingredient(id: 111, name: "salt and pepper"),Recipe.Ingredient(id: 222, name: "dried parsley"),Recipe.Ingredient(id: 333, name: "garlic powder"),Recipe.Ingredient(id: 444, name: "onion powder")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 3, step: "Roll the beef mixture into 1-inch round meatballs.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 4, step: "Add 1 tablespoon of olive oil to the skillet.",ingredients: [Recipe.Ingredient(id: 1, name: "olive oil")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 5, step: "Place the meatballs in the skillet (cook in twobatches if they won't all fit) and cook the meatballs completely, turning to brown on each sideevery 3-4 minutes. Once the meatballs are cooked through, remove them from the pan and setaside.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 6, step: "Toss the diced onion into the skillet. Cook the onion for 4-5 minutes, until it's beginning tosoften, stirring frequently.",ingredients: [Recipe.Ingredient(id: 1, name: "onion")], length: Recipe.TimeLength(number: 4, unit: "min"))])],servings: 2)
    ]

    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: [NSSortDescriptor(key: "dateWasBought", ascending: false)]) var coreDataCollection: FetchedResults<ShoppingWish>
    
    @State var inputField = ""
    
    @State var items = [IngredientChipModel]()

    @State var enablePersonalMode = true
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var userProfile: FetchedResults<Profile>
    @State var loadingRecepies = false
    @State var noResultTrigger = false
    
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
            Toggle(isOn: $enablePersonalMode) {
                Text("For me")
            }.padding().frame(height: 40)
            
            ZStack{
                
                List(searchedResults){res in
                    SearchResult(res: res)
                        .padding(.vertical, 2)
                    
                }
                .onAppear { UITableView.appearance().separatorStyle = .none
                    
                }
                .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
                loadingRecepies ?  Spinner(): nil
                noResultTrigger ? Text("Nothing found").font(.largeTitle).fontWeight(.bold).foregroundColor(Color.gray) : nil
                HStack{
                    Spacer()
                    Button(action: {
                        print("button clicked")
                        self.loadingRecepies = true
                        self.noResultTrigger = false
                        self.searchedResults = []
                        let inputAsArray = self.items.map{(ingredient: IngredientChipModel) -> String in
                            if(ingredient.wasBought){
                                return ingredient.name.lowercased()
                            }else{
                                return ""
                            }
                        }
                        let inputAsString = inputAsArray.filter({ $0 != ""}).joined(separator:",")
                        var diet = self.userProfile[0].userDietQuery
                        var cuisine = self.userProfile[0].userCuisineQuery
                        
                        if(!self.enablePersonalMode){
                            diet = ""
                            cuisine = ""
                        }
                        print("inputAsString",inputAsString)
                        self.networkManager.fetchRecipes(stringQueryOfIngredients: inputAsString , numberOfResults: 10, diet: diet ?? "", cuisine: cuisine ?? ""){
                            self.searchedResults = $0.results
                            self.loadingRecepies = false
                            print($0.results)
                            if($0.results.isEmpty){
                                self.noResultTrigger = true
                            }else{
                                self.loadingRecepies = false
                            }
                        }
                        
                    }) {
                        Text("Filter").foregroundColor(Color.white).padding(5)
                    }.frame(width:UIScreen.main.bounds.width / 2.3)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.green,radius: 5)
                    
                    Spacer()
                }.padding(.vertical , 10).offset(y: UIScreen.main.bounds.height/2 - 200)
            }
            
            
            
            

        }.onAppear(perform: { self.fetchCoreDataAsArray() } )
        
    }
    // map an array with type IngredientChipModel
    func fetchCoreDataAsArray(){
        items = Array(coreDataCollection.map { IngredientChipModel(name: $0.name!, wasBought: $0.wasBought, measure: $0.measure,quantity: $0.quantity) })
    }
    func addIngredient(){
        //arr.append( IngredientChipModel(name: inputField))
        
        items.insert(IngredientChipModel(name: self.inputField, wasBought: true, measure: "",quantity: 0),at: 0)
        self.inputField = ""
        
    }
}

struct SearchResult: View {
    let res: Recipe
    @State private var showRecepieDetailsSheet = false
    @State var scaleFactor: Double = 0
    var body: some View{
        HStack(alignment: .top){
            
            URLImage(URL(string: res.image)!, placeholder: { _ in
                Image("logo")            
                    .resizable()
                     .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 95)
            }){ proxy in
                proxy.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                    
                    .frame(width: 110, height: 95)
                    .cornerRadius(10)
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
                    ForEach(res.usedIngredients){
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
    let match: Recipe.UsedIngredient
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
               
                let bla = chipsArray.remove(at: index)
                print(chip.id , element.id , index,bla,chipsArray.map{String($0.name)})
            }
            
        }
    }
    
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}

