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
    
        Recipe(id: 551292, title: "Grandmother Paul's Fried Chicken",image: "https://spoonacular.com/recipeImages/291025-312x231.jpeg", spoonacularScore: 54.0, healthScore: 11.0, likes: 7, vegan: false, dishTypes: ["lunch","main course","main dish", "dinner"],readyInMinutes:  144.0, usedIngredients:[Recipe.UsedIngredient(id: 5006, amount: 2.5, unit: "pound", name: "chicken", originalString: "1 (2 1/2 pound) chicken, cut into pieces", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/whole-chicken.jpg"),Recipe.UsedIngredient(id: 1123, amount: 3.0, unit: "", name: "eggs", originalString: "3 eggs", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/egg.png")],missedIngredients: [Recipe.UsedIngredient(id: 1004615, amount: 4.0, unit: "servings", name: "crisco", originalString: "Crisco shortening, for frying", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/shortening.jpg ")],analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Heat shortening in a cast iron skillet to 350 degrees F.",ingredients: [Recipe.Ingredient(id: 1, name: "shortening")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Beat eggs with water in a small bowl. In a shallow bowl, season flour with pepper. Dip chicken pieces in egg mixture and then coat well in flour mixture. Carefully add to hot shortening, in batches if necessary, place lid on top of skillet, and fry until brown and crisp. Remember that dark meat requires a longer cooking time (about 13 to 14 minutes, compared to 8 to 10 minutes for white meat.)",ingredients: [Recipe.Ingredient(id: 111, name: "chicken pieces"),Recipe.Ingredient(id: 222, name: "shortening "),Recipe.Ingredient(id: 333, name: "pepper"),Recipe.Ingredient(id: 444, name: "water"),Recipe.Ingredient(id: 454, name: "egg")], length: Recipe.TimeLength(number: 21, unit: "minutes"))])],servings: 4),
        
        
        Recipe(id: 325270, title: "Classic Southern Fried Chicken",image: "https://spoonacular.com/recipeImages/325270-312x231.jpg", spoonacularScore: 8.0, healthScore: 0.8, likes: 25, vegan: false, dishTypes: ["antipasti","starter","snack", "appetizer","antipasto","hor d'oeuvre"],readyInMinutes:  45.0, usedIngredients:[ Recipe.UsedIngredient(id: 5006, amount: 1.0, unit: "", name: "chicken", originalString: "1 chicken, cut into 8 pieces", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/whole-chicken.jpg "),Recipe.UsedIngredient(id: 1123, amount: 2.0, unit: "large", name: "eggs", originalString: "2 large eggs", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/egg.png ")],missedIngredients: [Recipe.UsedIngredient(id: 4615, amount: 24.0, unit: "ounces", name: "solid vegetable shortening", originalString: "24 ounces solid vegetable shortening, such as Crisco", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/shortening.jpg "),Recipe.UsedIngredient(id: 1077, amount: 0.5, unit: "cup", name: "whole milk", originalString: "1/2 cup whole milk", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/milk.png")],analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Pat the chicken pieces dry and line a baking sheet with wax paper. In a large bowl, whisk the eggs with the milk.",ingredients: [Recipe.Ingredient(id: 1005006, name: "chicken pieces"),Recipe.Ingredient(id: 1123, name: "egg"),Recipe.Ingredient(id: 1077, name: "milk")], length: Recipe.TimeLength(number: 0, unit: "")),Recipe.Step(number: 2, step: "Add the chicken. In another bowl, whisk the flour with the seasoned salt and seasoned pepper. Dredge the chicken in the seasoned flour and transfer to the baking sheet.",ingredients: [Recipe.Ingredient(id: 1042047, name: "seasoned salt"),Recipe.Ingredient(id: 5006, name: "whole chicken"),Recipe.Ingredient(id: 1002030, name: "pepper"),Recipe.Ingredient(id: 20081, name: "all purpose flour")], length: Recipe.TimeLength(number: 0, unit: "")),Recipe.Step(number: 3, step: "In a 12-inch, cast-iron skillet, heat the vegetable shortening to 36",ingredients: [Recipe.Ingredient(id: 4615, name: "vegetable shortening")], length: Recipe.TimeLength(number: 0, unit: "")),Recipe.Step(number: 4, step: "Add all of the chicken and fry over moderate heat, turning occasionally, until deeply golden brown and an instant-read thermometer inserted nearest the bone registers 170, 20 to 24 minutes.",ingredients: [Recipe.Ingredient(id: 5006, name: "whole chicken")], length: Recipe.TimeLength(number: 20, unit: "minutes")),Recipe.Step(number: 5, step: "Drain the chicken on paper towels and serve right away.",ingredients: [Recipe.Ingredient(id: 5006, name: "whole chicken")], length: Recipe.TimeLength(number: 0, unit: ""))])],servings: 6)
        ,
         Recipe(id: 608206, title: "Homemade Chicken and Dumplings",image: "https://spoonacular.com/recipeImages/608206-312x231.jpg", spoonacularScore: 41.0, healthScore:3.8, likes: 513, vegan: false, dishTypes: ["antipasti","starter","snack", "appetizer","antipasto","hor d'oeuvre"],readyInMinutes:  45.0, usedIngredients:[ Recipe.UsedIngredient(id: 5006, amount: 1.0, unit: "", name: "whole chicken", originalString: "1 chicken, cut into 8 pieces", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/whole-chicken.jpg "),Recipe.UsedIngredient(id: 1123, amount: 2.0, unit: "large", name: "eggs", originalString: "2 large eggs", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/egg.png ")],missedIngredients: [Recipe.UsedIngredient(id: 4615, amount: 24.0, unit: "ounces", name: "solid vegetable shortening", originalString: "24 ounces solid vegetable shortening, such as Crisco", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/shortening.jpg "),Recipe.UsedIngredient(id: 1077, amount: 0.5, unit: "cup", name: "whole milk", originalString: "1/2 cup whole milk", imageUrl: "https://spoonacular.com/cdn/ingredients_100x100/milk.png")],analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Pat the chicken pieces dry and line a baking sheet with wax paper. In a large bowl, whisk the eggs with the milk.",ingredients: [Recipe.Ingredient(id: 1005006, name: "chicken pieces"),Recipe.Ingredient(id: 1123, name: "egg"),Recipe.Ingredient(id: 1077, name: "milk")], length: Recipe.TimeLength(number: 0, unit: "")),Recipe.Step(number: 2, step: "Add the chicken. In another bowl, whisk the flour with the seasoned salt and seasoned pepper. Dredge the chicken in the seasoned flour and transfer to the baking sheet.",ingredients: [Recipe.Ingredient(id: 1042047, name: "seasoned salt"),Recipe.Ingredient(id: 5006, name: "whole chicken"),Recipe.Ingredient(id: 1002030, name: "pepper"),Recipe.Ingredient(id: 20081, name: "all purpose flour")], length: Recipe.TimeLength(number: 0, unit: "")),Recipe.Step(number: 3, step: "In a 12-inch, cast-iron skillet, heat the vegetable shortening to 36",ingredients: [Recipe.Ingredient(id: 4615, name: "vegetable shortening")], length: Recipe.TimeLength(number: 0, unit: "")),Recipe.Step(number: 4, step: "Add all of the chicken and fry over moderate heat, turning occasionally, until deeply golden brown and an instant-read thermometer inserted nearest the bone registers 170, 20 to 24 minutes.",ingredients: [Recipe.Ingredient(id: 5006, name: "whole chicken")], length: Recipe.TimeLength(number: 20, unit: "minutes")),Recipe.Step(number: 5, step: "Drain the chicken on paper towels and serve right away.",ingredients: [Recipe.Ingredient(id: 5006, name: "whole chicken")], length: Recipe.TimeLength(number: 0, unit: ""))])],servings: 6)

    ]
    
    // Core Data ShoppingWish
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: [NSSortDescriptor(key: "dateWasBought", ascending: false)]) var coreDataCollection: FetchedResults<ShoppingWish>
    // user input
    @State var inputField = ""
    // Ingredients Array
    @State var items = [IngredientChipModel]()
    // on/off personalisation of search. Use profile settings of not
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
                Text("For me").onTapGesture {
                    
                      for index in self.coreDataCollection {
                              
                        self.moc.delete(index)
                              if self.moc.hasChanges{
                                  try? self.moc.save()
                              }
                          }
                    print(self.coreDataCollection)
                }
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
                        print("send request to server")
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
    // add ingredient to current list of ingredients
    func addIngredient(){
       items.insert(IngredientChipModel(name: self.inputField, wasBought: true, measure: "",quantity: 0),at: 0)
        self.inputField = ""
        
    }
}
//  Sub View in form of square button to visialise json objects, that represent recipies
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
// Visualissation of Ingredien as a Chip
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
    
    // delete Chip from Grid
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

