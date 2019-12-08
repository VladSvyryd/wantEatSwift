//
//  I_HaveView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI

struct I_HaveView: View {
    
    //managedObjectContext
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: [NSSortDescriptor(key: "dateWasBought", ascending: false)]) var sItems: FetchedResults<ShoppingWish>
   
    var body: some View {
        NavigationView{
            List{
                
                ForEach(self.sItems, id: \.id){obj in //\.id
                    obj.wasBought ?
                        IngredientVeiw(item: obj)  //?? "Unkown"
                            .listRowInsets(EdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20)) : nil
                    
                }
                .onDelete(perform: self.delete)
            }.padding(.leading, 0.0)
        }.navigationBarTitle("My Ingredients",displayMode: .inline)
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


struct IngredientVeiw : View{
    var item: ShoppingWish
    @State private var doneIsShowing = true
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View{
        NavigationLink(destination: MeasuresView(item: self.item, viewName: "Ihave")) {
            HStack{
                HStack{
                    Spacer()
                    Image("done")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 12)
                        
                        .animation(.interpolatingSpring(mass: 1.0,stiffness: 100.0,damping: 10.5,initialVelocity: 0))
                        .offset(x: !self.doneIsShowing ?  CGFloat(-120) : CGFloat(0.0))
                    
                }.frame(width: 20.0, height: 20.0).onTapGesture {
                    
                    withAnimation {
                        self.doneIsShowing.toggle()
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.item.wasBought.toggle()
                        
                        self.item.dateWasBought = self.item.dateCreated
                        if self.moc.hasChanges{
                            try? self.moc.save()
                        }
                    }
                    
                }
                
                VStack(alignment: .leading){
                    Text("\(item.name ?? "value")")
                    HStack(spacing: 2.0){
                        if(self.item.quantity > 0 ){
                            Text("\(self.item.quantity, specifier:  "%.0f")").foregroundColor(Color.gray).font(.system(size: 15))
                        }
                        if(self.item.measure != ""){
                            Text("\(self.item.measure ?? "N/A")").foregroundColor(Color.gray).font(.system(size: 15))
                        }
                    }
                }
                Spacer()
                
                Text("\(formatDateAgo(dateToFormat: item.dateWasBought ?? Date()))").foregroundColor(Color.gray).font(.system(size: 17))
            }
        }.navigationBarTitle("My Ingredients",displayMode: .inline)
    }
}
func formatDateAgo(dateToFormat:Date) -> String{
    
    // ask for the full relative date
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated
    
    // get exampleDate relative to the current date
    return formatter.localizedString(for: dateToFormat, relativeTo: Date())
    
}
struct IngredientDetailView : View{
    var item: ShoppingWish
    
    var body: some View{
        HStack{
            
            VStack{
                Text("\(item.name ?? "Unknown")")
                
                
            }
        }
    }
}
struct I_HaveView_Previews: PreviewProvider {
    static var previews: some View {
        I_HaveView()
    }
}
