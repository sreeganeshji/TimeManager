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
                    
                    Picker(selection: $category.color, label: HStack{
                        Text("Color:")
                        Spacer()
                        
                        }
                        
                    ) {
                        ForEach(self.data.colors,id:\.self)
                        {
                            color in
                            HStack{
//                                Spacer()
                              
                                RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(color)
                                    .frame(width:30)
//                                Spacer()
                                Text(color.description)
                                                              Spacer()

                            }
                        }
                    }
                }
                
            }
//            .navigationBarTitle("Category: \(category.name)")
    
        
    }
}

struct CategoryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetail(category: .constant(models.category("work"))).environmentObject(models())
    }
}
