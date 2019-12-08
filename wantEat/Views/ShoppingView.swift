//
//  ShoppingView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import CoreData

// imported external library of sheetView from https://github.com/AndreaMiotto/PartialSheet
//import PartialSheet


struct ShoppingView: View {
    //managedObjectContext
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: []) var sItems: FetchedResults<ShoppingWish>
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @State var toBuyInput = ""
    @State var items = ["String","Blow"]
    var safeareaBottomHeight:CGFloat = 80
    
    @State var openPickerWindow = false
    @State var showClearButton = false
    var body: some View {
        
        NavigationView{
            
            
            
            VStack(alignment: .center){
                List{
                    
                    ForEach(self.sItems, id: \.id){obj in //\.id
                        !obj.wasBought ?
                            ShoppingItemView(item: obj)  //?? "Unkown"
                                .listRowInsets(EdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)) : nil
                        
                    }
                    .onDelete(perform: self.delete)
                }.padding(.leading, -20.0)
                
                
                VStack{
                    Group{
                        Button(action: {
                            //self.items.insert("\(self.toBuyInput)", at: 0)
                            if(self.toBuyInput.isEmpty) {return}
                            self.createShoopingItem()
                            
                            
                        }){
                            Text("Create Item")
                                .foregroundColor(Color.white).padding()
                        }.background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                    }
                    
                }
                
                VStack{
                    
                    TextField("write", text: self.$toBuyInput,  onCommit: createShoopingItem ).modifier( ClearButton(text: self.$toBuyInput))
                        .padding(.horizontal,15).padding(.vertical,20).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    
                }.padding(.bottom, self.keyboard.currentHeight != 0 ? self.keyboard.currentHeight - self.safeareaBottomHeight:self.keyboard.currentHeight ).animation(.spring())
                
                
                
            }
                
            .navigationBarTitle("Shopping List",displayMode: .inline)
            
            
        }
        
        
    }
    func openSheet(){
        withAnimation{
            self.openPickerWindow = true
        }
        
    }
    // may be used for closing keyboards
    private func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
    func createShoopingItem(){
        if(self.toBuyInput.isEmpty) {return}
        let shoppingWish = ShoppingWish(context: self.moc)
        shoppingWish.id = UUID()
        shoppingWish.name = "\(self.toBuyInput)"
        shoppingWish.dateCreated = Date()
        //shoppingWish.quantity = 10
        //shoppingWish.measure = "L"
        if self.moc.hasChanges{
            try? self.moc.save()
        }
        self.toBuyInput = ""
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
    let formater = NumberFormatter()
    var body: some View {
        
        
        
        NavigationLink(destination: MeasuresView(item: self.item, viewName: "Shopping")) {
            
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
                Text("\(self.item.name ?? "Unknowing")")
                Spacer()
                HStack(spacing: 2.0){
                    if(self.item.quantity > 0 ){
                        Text("\(self.item.quantity, specifier:  "%.0f")").foregroundColor(Color.gray).font(.system(size: 15))
                    }
                    
                    if(self.item.measure != ""){
                        Text("\(self.item.measure ?? "N/A")").foregroundColor(Color.gray).font(.system(size: 15))
                    }
                }
                
                
            }.padding(.trailing,20).onTapGesture {
                
                withAnimation {
                    self.doneIsShowing.toggle()
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.item.wasBought.toggle()
                    self.item.dateWasBought = Date()
                    if self.moc.hasChanges{
                        try? self.moc.save()
                    }
                }
                
            }
        }
        
    }
    
}

// View that have been opened as Navigation Link
// Funtions : change value of measures and quaantity of ShoppingItem
struct MeasuresView:View {
    var item: ShoppingWish
    var viewName: String?
    @Environment(\.managedObjectContext) var moc
    // data to use as picker
    @State var data: [(String, [String])] = [
        ("One", [0, 100, 200, 250, 300, 500, 750 , 1, 2, 3, 5, 10].map { "\($0)" }),
        ("Two",["package(s)","L", "g","unit","mg", "ml", "kg"].map { "\($0)" })
    ]
    // state of multiple picker
    @State var selection: [String] = ["1","unit"].map { "\($0)" }
    // to dismiss View
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        NavigationView{
            VStack(spacing: 25){
                Spacer()
                VStack{
                    if(viewName == "Shopping"){
                        Text("created on \(formatDate(dateToFormat: item.dateCreated ?? Date()))")
                    }else if(viewName == "Ihave"){
                         Text("bought on \(formatDate(dateToFormat: item.dateWasBought ?? Date()))")
                    }
                   
                    
                }
                VStack{
                    Section(header: Text("Pick up product measures").font(.title)){
                        MultiPicker(data: data, selection: $selection).frame(height: 200)
                    }
                    
                }.padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow( color: Color( hue: 0.0, saturation: 0.0, brightness: 0.84), radius:  CGFloat(6), x: CGFloat(0), y: CGFloat(3))
                VStack{
                    HStack{
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Back").foregroundColor(Color.white).padding()
                        }.frame(width:UIScreen.main.bounds.width / 2.3)
                            .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.orange, radius: 5)
                        Spacer()
                        Button(action: {
                             self.changeShoppingItem(shoppingWish: self.item)
                            
                            self.presentationMode.wrappedValue.dismiss()
                           
                        }) {
                            Text("Save").foregroundColor(Color.white).padding()
                        }.frame(width:UIScreen.main.bounds.width / 2.3)
                            .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.green,radius: 5)
                    }
                    
                }
                
            }.padding()
            
        }.navigationBarTitle("\(item.name ?? "Unknown")")
        
    }
    func changeShoppingItem(shoppingWish: ShoppingWish){
       
        shoppingWish.quantity = Double(selection[0])!
        shoppingWish.measure = selection[1]
                   if self.moc.hasChanges{
                       try? self.moc.save()
                   
               }
         print(shoppingWish.quantity)
    }
    func formatDate(dateToFormat:Date) -> String{
        
        // ask for the full relative date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "dd.M.yy."
        // get exampleDate relative to the current date
        return formatter.string(from: dateToFormat) 
        
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
