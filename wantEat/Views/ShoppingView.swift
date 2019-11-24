//
//  ShoppingView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import CoreData


struct ShoppingView: View {
    //managedObjectContext
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: []) var sItems: FetchedResults<ShoppingWish>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @State var toBuyInput = ""
    @State var items = ["String","Blow"]
    var safeareaBottomHeight:CGFloat = 80
    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .center){
                List{
                    
                    ForEach(sItems, id: \.id){obj in //\.id
                        !obj.wasBought ?
                            ShoppingItemView(item: obj)  //?? "Unkown"
                                .listRowInsets(EdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)) : nil
                        
                    }
                    .onDelete(perform: delete)
                }.padding(.leading, -20.0)
                VStack{
                    Group{
                        Button(action: {
                            //self.items.insert("\(self.toBuyInput)", at: 0)
                            if(self.toBuyInput.isEmpty) {return}
                            
                            let shoppingWish = ShoppingWish(context: self.moc)
                            shoppingWish.id = UUID()
                            shoppingWish.name = "\(self.toBuyInput)"
                            
                            if self.moc.hasChanges{
                                try? self.moc.save()
                            }
                            
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
            .navigationBarTitle("Shopping List",displayMode: .inline)
            
        }
        
    }
    func delete(at offsets: IndexSet){
        for index in offsets {
            let sItem = sItems[index]
            moc.delete(sItem)
            if self.moc.hasChanges{
                try? self.moc.save()
            }
        }
    }
}

struct ShoppingItemView:View {
    @Environment(\.managedObjectContext) var moc
    var item: ShoppingWish
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
            Text("\(item.name ?? "Unknowing")")
            
        }.padding(.trailing,20).onTapGesture {
            
            withAnimation {
                self.doneIsShowing.toggle()
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.item.wasBought.toggle()
                if self.moc.hasChanges{
                    try? self.moc.save()
                }
            }
            
        }
    }
}

struct ShoppingView_Previews: PreviewProvider {
    static var previews: some View {
        
        //  Was taken from https://stackoverflow.com/questions/57700304/previewing-contentview-with-coredata
        // It fixes crash of Preview for developing UI.
        // It allows to use Core Data in Previews
        // Wrote by bjnortier 29 Aug 2019
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ShoppingView().environment(\.managedObjectContext, context)
    }
}
