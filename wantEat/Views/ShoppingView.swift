//
//  ShoppingView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct ShoppingView: View {
    @State var toBuyInput = ""
    
    @State var items = [String]()
    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .center){
                Group{
                    TextField("write", text: $toBuyInput).padding(.horizontal,15).padding(.vertical,20).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                }
               
                List{
                    
                    ForEach(items, id: \.self){obj in
                        Text(obj)
                    }
                    .onDelete(perform: delete)
                }
                VStack{
                    Group{
                        
                    
                    Button(action: {
                        self.items.insert("\(self.toBuyInput)", at: 0)
                    }){
                        Text("Create Item")
                            .foregroundColor(Color.white).padding()
                    }.background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 10)
                }
                    
                }
                    
            }
            
        }.navigationBarTitle("Test")
        .navigationBarItems(trailing: EditButton())
        
    }
    func delete(at offsets: IndexSet){
        if let first = offsets.first{
            items.remove(at: first)
        }
    }
}

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingView()
    }
}
