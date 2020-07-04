//
//  CategoryDetail.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/15/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct CategoryDetail: View {
    @Binding var category:models.category
    @EnvironmentObject var data:models
    @Binding var showSheet:Bool
    var body: some View {
       
            
            Form{
                Section{
                    HStack{
                    Text("Name:")
                Spacer()
              
//                Text(category.name).bold()
                        TextField("", text: $category.name)
                    }
           
//                    NavigationLink(destination:CategoryColor(category: $category)){
//                    HStack{
//                Text("Color:")
//                     Spacer()
//
//                        Circle().foregroundColor(category.color)
//
//
//                    }
//                    }
                    
                    Picker(selection: $category.color, label: 
                        Text("Color:")

                    ) {
                        ForEach(self.data.colors,id:\.self)
                        {
                            color in
                            HStack{
//                                Spacer()
                              
//                                RoundedRectangle(cornerRadius: 4)
//                                .foregroundColor(color)
//                                    .frame(width:30)
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(color)
//                                Spacer()
                                Text(self.data.getColorName(color))
                                                              Spacer()

                            }
                            .tag(self.data.getColorName(color))
                        }
                    }
                .labelsHidden()
                }
                
            }
            .navigationBarTitle("\(category.name)")
            .navigationBarItems(trailing: Button(action:{
                self.showSheet = false
            })
            {
                Text("Done")
            })
    
        
    }
}

struct CategoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetail(category: .constant(models.category("work")), showSheet: .constant(true)).environmentObject(models())
    }
}
