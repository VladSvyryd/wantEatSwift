//
//  ShoppingView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct ShoppingView: View {
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @State var toBuyInput = ""
    @State var items = ["String","Blow"]
    var safeareaBottomHeight:CGFloat = 80
    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .center){
                List{
                    
                    ForEach(items, id: \.self){obj in
                        ShoppingItem(item: obj).listRowInsets(EdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20))
                        
                    }
                    .onDelete(perform: delete)
                }.padding(.leading, -20.0)
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
                VStack{
                    TextField("write", text: $toBuyInput).padding(.horizontal,15).padding(.vertical,20).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                }.padding(.bottom, keyboard.currentHeight != 0 ? keyboard.currentHeight - safeareaBottomHeight:keyboard.currentHeight ).animation(.spring())
                
                
            }
            .navigationBarTitle("Shopping",displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
        
    }
    func delete(at offsets: IndexSet){
        if let first = offsets.first{
            items.remove(at: first)
        }
    }
}

struct ShoppingItem:View {
    var item: String
    @State private var doneIsShowing = false
    var body: some View {
        HStack(spacing: 18.0){
            HStack{
                Spacer()
                Image("done")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 12)
                    
                    .animation(.interpolatingSpring(mass: 1.0,stiffness: 100.0,damping: 10.5,initialVelocity: 0))
                    .offset(x: !self.doneIsShowing ?  CGFloat(-120) : CGFloat(0.0))
                  
            }.frame(width: 40.0, height: 20.0)
            Text(item)
            
        }.padding(.trailing,20).onTapGesture {
           
                withAnimation {
                    self.doneIsShowing.toggle()
               
                
            }
        }
    }
}

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingView()
    }
}
