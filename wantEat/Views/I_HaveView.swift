//
//  I_HaveView.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 16.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
struct ShoppingWishTest : Identifiable{
    var name: String
    var id: UUID
    var quantity: Double
    var wasBought: Bool
    var dataCreated: Date
    var dateWasBought: Date
    var measure: String
}
struct I_HaveView: View {
    @State private var rotateCamera = false
    //managedObjectContext
    @Environment(\.managedObjectContext) var moc
    
    //@FetchRequest(entity: ShoppingWish.entity(), sortDescriptors: []) var sItems: FetchedResults<ShoppingWish>
    var sItems = [ShoppingWishTest(name: "Milk", id: UUID(), quantity: 1, wasBought: true, dataCreated: Date().addingTimeInterval(-60000), dateWasBought: Date().addingTimeInterval(-10000), measure: "L")]
    var body: some View {
        NavigationView{
            List{
                
                ForEach(sItems){obj in //\.id
                    obj.wasBought ?
                        
                        IngredientVeiw(item: obj)  //?? "Unkown"
                            .listRowInsets(EdgeInsets(top: 13, leading: 20, bottom: 13, trailing: 20))
                        
                        : nil
                    
                }
                .onDelete(perform: delete)
            }.padding(.leading, 0.0)
        }.navigationBarTitle("My Ingredients",displayMode: .inline)
    }
    func delete(at offsets: IndexSet){
       
    }
    
}


struct IngredientVeiw : View{
    var item: ShoppingWishTest
    @State private var doneIsShowing = true
    @Environment(\.managedObjectContext) var moc
    // ask for the full relative date
    
    
    var body: some View{
        NavigationLink(destination: IngredientDetailView(item: item)) {
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
                      //  self.item.wasBought.toggle()
                        //if self.moc.hasChanges{
                       //     try? self.moc.save()
                       // }
                    }
                    
                }
                
                VStack{
                    Text("\(item.name ?? "Unknown")")
                    Text("\(item.quantity, specifier: "%.0f") \(item.measure)").foregroundColor(Color.gray).font(.system(size: 15))
                }
                Spacer()
               
                Text("\(formatDateAgo(dateToFormat: item.dateWasBought))").foregroundColor(Color.gray).font(.system(size: 17))
            }
        }.navigationBarTitle("My Ingredients")
    }
}
func formatDateAgo(dateToFormat:Date) -> String{
    
   // the date you want to format
    let exampleDate = dateToFormat

    // ask for the full relative date
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full

    // get exampleDate relative to the current date
    return formatter.localizedString(for: exampleDate, relativeTo: Date())
    
}
struct IngredientDetailView : View{
    var item: ShoppingWishTest
    
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
