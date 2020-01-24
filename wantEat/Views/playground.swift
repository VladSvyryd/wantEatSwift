//
//  playground.swift
//  wantEat
//
//  Created by Vlad Svyryd on 12.01.20.
//  Copyright © 2020 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import URLImage

struct playground: View {
    @State var t = true
    @State var isLoading = false
    //var spinner = UIActivityIndicatorView(style: .whiteLarge)
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var body: some View {
        VStack{
            Toggle(isOn: $t) {
                       Text("For me")
                   }
          Spinner()
            Button(action: {
                self.isLoading.toggle()
            }, label: {
                Text("push")
            })
            Text("Nothing found").font(.largeTitle).fontWeight(.bold).foregroundColor(Color.gray)
//            URLImage(URL(string: "https://i.pinimg.com/originals/44/ce/2c/44ce2cfa6267fde44790205135a78051.jpg")!){
//                proxy in
//                proxy.image.resizable().clipped().frame(width: 120, height: 160)
//            }
            SearchResult(res:  Recipe(id: 0, title: "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",image: "https://scx1.b-cdn.net/csz/news/800/s2019/nasamoonrock.jpg", spoonacularScore: 4.0, healthScore: 19.0, likes: 300, vegan: true, dishTypes: ["lunch","lunch main","course main", "dish dinner"],readyInMinutes:  45.0, usedIngredients:[ Recipe.UsedIngredient(id: 1, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 11, amount: 5, unit: "g", name: "potato", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 22, amount: 5, unit: "g", name: "cheese", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 33, amount: 5, unit: "g", name: "champinions", originalString: "123", imageUrl: "lunch "),Recipe.UsedIngredient(id: 44, amount: 4, unit: "large", name: "key", originalString: "123", imageUrl: "lunch ")],missedIngredients: [Recipe.UsedIngredient(id: 156, amount: 5, unit: "g", name: "TOMATO", originalString: "123", imageUrl: "lunch ")],analyzedInstructions: [Recipe.AnalyzedInstruction(steps:[Recipe.Step(number: 1, step: "Place a large skillet over medium heat.",ingredients: [Recipe.Ingredient(id: 1, name: "bread")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 2, step: "Mix the ground beef with the garlic powder, onion powder, parsley flakes, salt and pepper.",ingredients: [Recipe.Ingredient(id: 111, name: "salt and pepper"),Recipe.Ingredient(id: 222, name: "dried parsley"),Recipe.Ingredient(id: 333, name: "garlic powder"),Recipe.Ingredient(id: 444, name: "onion powder")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 3, step: "Roll the beef mixture into 1-inch round meatballs.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 4, step: "Add 1 tablespoon of olive oil to the skillet.",ingredients: [Recipe.Ingredient(id: 1, name: "olive oil")], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 5, step: "Place the meatballs in the skillet (cook in twobatches if they won't all fit) and cook the meatballs completely, turning to brown on each sideevery 3-4 minutes. Once the meatballs are cooked through, remove them from the pan and setaside.",ingredients: [], length: Recipe.TimeLength(number: 4, unit: "min")),Recipe.Step(number: 6, step: "Toss the diced onion into the skillet. Cook the onion for 4-5 minutes, until it's beginning tosoften, stirring frequently.",ingredients: [Recipe.Ingredient(id: 1, name: "onion")], length: Recipe.TimeLength(number: 4, unit: "min"))
                       
                       
                   ])]))
                                  
        }
       
    }
}
struct Spinner: View {
    @State var isLoading = true
     var body: some View {
        Circle()
                        .trim(from: 0.5, to: 1)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .blue, .purple, .red]), center: .center), lineWidth: 4)
                       
                       .frame(width:80, height: 80)
                  
                       .rotationEffect(.degrees(!isLoading ? 0 : -360), anchor: .center)
                       
                       .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                   
                       .onAppear(){
                           self.isLoading.toggle()
                   }
    }
}


struct playground_Previews: PreviewProvider {
    static var previews: some View {
        playground()
    }
}
