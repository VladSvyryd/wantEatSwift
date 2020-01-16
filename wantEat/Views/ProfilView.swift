//
//  Profil.swift
//  wantEat
//
//  Created by Vladyslav Svyrydonov on 20.10.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import SwiftUI
import CoreData
struct Diet : Identifiable, Hashable{
    var id: Int
    var name: String
    var description: String
}

struct ProfilView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Profile.entity(), sortDescriptors: []) var userProfile: FetchedResults<Profile>
    @FetchRequest(entity: DietList.entity(), sortDescriptors: []) var dietList: FetchedResults<DietList>
    //    var dietVariants = [
    //        Diet(id: 0, name: "Gluten Free", description: "Eliminating gluten means avoiding wheat, barley, rye, and other gluten-containing grains and foods made from them (or that may have been cross contaminated)."),Diet(id: 1, name: "Ketogenic", description: "The keto diet is based more on the ratio of fat, protein, and carbs in the diet rather than specific ingredients. Generally speaking, high fat, protein-rich foods are acceptable and high carbohydrate foods are not."),Diet(id: 2, name: "Vegetarian", description: "No ingredients may contain meat or meat by-products, such as bones or gelatin."), Diet(id: 3, name: "Lacto-Vegetarian", description: "All ingredients must be vegetarian and none of the ingredients can be or contain egg."), Diet(id: 4, name: "Ovo-Vegetarian", description: "All ingredients must be vegetarian and none of the ingredients can be or contain dairy."), Diet(id: 5, name: "Vegan", description: "No ingredients may contain meat or meat by-products, such as bones or gelatin, nor may they contain eggs, dairy, or honey."),Diet(id: 6, name: "Pescetarian", description: "Everything is allowed except meat and meat by-products - some pescetarians eat eggs and dairy, some do not."), Diet(id: 7, name: "Paleo", description: "Allowed ingredients include meat (especially grass fed), fish, eggs, vegetables, some oils (e.g. coconut and olive oil), and in smaller quantities, fruit, nuts, and sweet potatoes. We also allow honey and maple syrup (popular in Paleo desserts, but strict Paleo followers may disagree). Ingredients not allowed include legumes (e.g. beans and lentils), grains, dairy, refined sugar, and processed foods."), Diet(id: 8, name: "Primal", description: "Very similar to Paleo, except dairy is allowed - think raw and full fat milk, butter, ghee, etc."), Diet(id: 9, name: "Whole30", description: "Allowed ingredients include meat, fish/seafood, eggs, vegetables, fresh fruit, coconut oil, olive oil, small amounts of dried fruit and nuts/seeds. Ingredients not allowed include added sweeteners (natural and artificial, except small amounts of fruit juice), dairy (except clarified butter or ghee), alcohol, grains, legumes (except green beans, sugar snap peas, and snow peas), and food additives, such as carrageenan, MSG, and sulfites.")
    //    ]
    
    var cuisine = ["none","African","American",
                   "British",
                   "Cajun",
                   "Caribbean",
                   "Chinese",
                   "Eastern European",
                   "European",
                   "French",
                   "German",
                   "Greek",
                   "Indian",
                   "Irish",
                   "Italian",
                   "Japanese",
                   "Jewish",
                   "Korean",
                   "Latin American",
                   "Mediterranean",
                   "Mexican",
                   "Middle Eastern",
                   "Nordic",
                   "Southern",
                   "Spanish",
                   "Thai",
                   "Vietnamese"]
    
    
    
    //@State private var selectedItems: Set = [UUID() ]
    //@State var dietSheetActive = false
    //@State var selectionSet = Set<Int>([2,5])
    @State var dietString = ""
    @State var cuisineString = ""
    @State private var selectedModeForDiet = 9
    @State private var selectedModeForCuisine = 0
    var body: some View {
        NavigationView {
            // 3.
            Form {
                // 4.
                Section(header: Text("General Settings")){
                    // Pickers work only one time per being in Profile View, according to stackoverflow.com posts, it is wellknown bug and is still not fixed
                    Picker(selection: $selectedModeForDiet, label: Text("Diet")) {
                        ForEach(0..<dietList.count) { index in
                            Text("\(self.dietList[index].name ?? "n/a")")
                            
                        }
                    }
                    Picker(selection: $selectedModeForCuisine, label: Text("Cuisine")) {
                        ForEach(0..<cuisine.count) { index in
                            Text("\(self.cuisine[index])")
                            
                        }
                    }
                     
                }.onAppear{
                    print(self.userProfile[0])
                }
                
                Section(header: Text("About me")) {
                    NavigationLink(destination: SimpleNavigationView(inputLineTupel: (title: "Name", oldInput: "\(userProfile[0].name ?? "User")"), profile: userProfile[0])) {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text("\(userProfile[0].name ?? "User")")
                            
                        }
                    }
                    HStack{ Spacer()
                        Button(action: {
                            self.saveProfileStatus(profile: self.userProfile[0])
                            
                        }) {
                            Text("Save").foregroundColor(Color.white).padding(5)
                        }.frame(width:UIScreen.main.bounds.width / 2.3)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.green,radius: 5)
                        Spacer()
                    }
                    
                }.navigationBarTitle("Profile")
            }
        }
    }
    func saveProfileStatus(profile: Profile){
        profile.userDietQuery = dietList[selectedModeForDiet].name
        profile.userCuisineQuery = cuisine[selectedModeForCuisine]
        if self.moc.hasChanges{
                   try? self.moc.save()
                   
               }
    }
}
struct SimpleNavigationView : View{
    var inputLineTupel: (title:String,oldInput:String)
    @State var input = ""
    var profile: Profile
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View{
        Form{
            Section(header: Text("Set Name")) {
                VStack{
                    
                    
                    HStack {
                        Text(inputLineTupel.title)
                        Spacer()
                        TextField("", text:  $input)
                    }.onAppear{
                        self.input = self.inputLineTupel.oldInput
                    }
                }
                
                HStack{ Spacer()
                    Button(action: {
                        self.saveName(profile: self.profile)
                    }) {
                        Text("Done").foregroundColor(Color.white).padding(5)
                    }.frame(width:UIScreen.main.bounds.width / 2.3)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.green,radius: 5)
                }}
        }
        
        
    }
    func saveName(profile: Profile){
        profile.name = input
        if self.moc.hasChanges{
            try? self.moc.save()
            
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}








struct SelectRow: View{
    @Environment(\.managedObjectContext) var moc
    @State var diet: DietList
    var cuisine: String?
    @State var isSelected:Bool
    var  body: some View{
        HStack{
            Text("\(diet.name ?? "n/a")")
            Spacer().frame(height: 40)
            isSelected ?
                Image(systemName:  "checkmark").foregroundColor(Color.blue) : nil
        }.contentShape(Rectangle()).foregroundColor(Color.red)
            .onTapGesture {
                //self.isSelected.toggle()
                withAnimation {
                    self.isSelected.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    self.diet.enabled.toggle()
                    if self.moc.hasChanges{
                        try? self.moc.save()
                        print(self.diet)
                    }
                }
                
                
        }
    }
    func changeDietItem(diet: DietList){
        
        
        
        
        
    }
}
struct MultiSelectionPicker: View{
    var title: String
    var diets: FetchedResults<DietList>
    
    var body: some View{
        VStack(alignment: .leading){ Text("\(title)").font(.largeTitle).fontWeight(.heavy).multilineTextAlignment(.leading)
            List(self.diets, id: \.self.id){ diet in
                SelectRow(diet: diet, isSelected: diet.enabled)
            }
        }
    }
}
struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilView()
    }
}
