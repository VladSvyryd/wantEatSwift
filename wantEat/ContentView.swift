//
//  ContentView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.R®®®®
//

import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(red: 0.5, green: 234.4, blue: 234.3, alpha: 0.67)
    }
    @State private var rotateCamera = false
    var body: some View {
        
        TabView {
            KitchenView().tabItem {
                VStack{
                    Image("coffee-table")
                    Text("Kitchen")
                }
                
            }.tag(1)
            I_HaveView().tabItem{
                VStack{
                    Image("list")
                    Text("I have")
                }
            }.tag(2)
            
            RecipeView().tabItem{
                VStack{
                    Image("frying-pan")
                    Text("Recipe")
                }
            }.tag(3)
            ShoppingView().tabItem{
                VStack{
                    Image("shopping-basket")
                    Text("Shopping")
                }
            }.tag(4)
            ProfilView().tabItem{
                VStack{
                    Image("gingerbread-man")
                    Text("Profile")
                }
            }.tag(5)
        }
    }
}

struct   ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
