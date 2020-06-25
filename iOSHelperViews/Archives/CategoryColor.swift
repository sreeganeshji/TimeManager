//
//  CategoryColor.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/16/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct CategoryColor: View {
    @Binding var category:models.category
    @EnvironmentObject var data:models
    var red:Color?
    var gem:GeometryProxy?
    var body: some View {
//        gem?.frame(in: .local)
        GeometryReader{
            geometry in
    
        Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("")) {
            ForEach(self.data.colors,id:\.self)
            {
                color in
                HStack{
                    Text(color.description)
                    RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(color)

                }
            }
        }
        .frame(width:geometry.size.width,height:500)
        }

//    .navigationBarTitle("Color")
    }
}

struct CategoryColor_Previews: PreviewProvider {
    static var previews: some View {
        CategoryColor(category: .constant (models.category("Work"))).environmentObject(models())
    }
}
