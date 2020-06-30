//
//  addCategoryiOS.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct addCategoryiOS: View {
    @State var activeView:Binding<Bool>
    @EnvironmentObject var data:models
    @State var category:models.category = models.category("")
    
    
    func addCatToList(category: models.category)
    {
        let len = self.data.categories.count
            var catLocal = category
        if self.category.name != ""
        {
            self.data.categories.append(catLocal)
            self.category = models.category("")
        }
    }
    
    var body: some View {
        NavigationView{
                List
                    {
                        TextField("Name", text: self.$category.name)
                        Picker( selection: self.$category.color,label: Text("Color")) {
                            ForEach(data.colors,id: \.self)
                            {
                                color in
                                HStack{
                                    Image(systemName:"bookmark.fill").foregroundColor(color)
                                    Text(color.description)
                                    Spacer()
                                }
                                    .tag(self.data.getColorName(color))
                
//                            .padding()
                            }
                        }
                    .labelsHidden()
//                        .tabItem({Text("Stuff")})
                }
    .padding()
    .navigationBarTitle("Add Category")
        .navigationBarItems(trailing:  Button(action:
                           {
                               self.addCatToList(category: self.category)
                               self.activeView.wrappedValue = false
                       }) {
                           Text("Add")
                       })
         
    }
            
    }
        }
        

struct addCatiOS_Previews: PreviewProvider {
    static var previews: some View {
        addCategoryiOS(activeView: .constant(false)).environmentObject(models())
    }
}
