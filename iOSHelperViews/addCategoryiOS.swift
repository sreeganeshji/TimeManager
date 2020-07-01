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
    @State var colorVal:Color = .blue
    
    func addCatToList()
    {
        self.category.color = self.data.getColorName(self.colorVal)
        let len = self.data.categories.count
        var catLocal = self.category
        if self.category.name != ""
        {
            self.data.categories.append(catLocal)
//            self.category = models.category("")
        }
    }
    
    var body: some View {
        NavigationView{
                List
                    {
                        TextField("Name", text: self.$category.name)
                        selectFromColors(colorVal: self.$colorVal, colors: self.data.colors)
//                        .tabItem({Text("Stuff")})
                }
    .padding()
    .navigationBarTitle("Add Category")
        .navigationBarItems(trailing:  Button(action:
                           {
                               self.addCatToList()
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
