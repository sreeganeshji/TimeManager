//
//  selectFromCategory.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct selectFromCategory: View {
    @Binding var categoryInd:Int
    var categoryList:[models.category]
  
    func getColor(_ colorName:String)->Color
    {
        switch colorName {
        case "gray":
            return .gray
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "red":
            return .red
        case "purple":
            return .purple
        case "pink":
            return .pink
        case "orange":
            return .orange
        case "green":
            return .green
        default:
            return .orange
        }
    }

    
    var body: some View {
           Picker( selection: self.$categoryInd,label: Text("Category")) {
                                    ForEach(self.categoryList.indices,id: \.self)
                                    {
                                        ind in
                                        HStack{
                                            Image(systemName:"bookmark.fill").foregroundColor(self.getColor(self.categoryList[ind].color))
                                           
                                            Text(self.categoryList[ind].name).tag(ind)
                                            Spacer()
                                        }
                                    .tag(ind)
        //                                .tag(category)
        //                            .padding()
                                    }

                                }
                            .labelsHidden()
    }
}

struct selectFromCategory_Previews: PreviewProvider {
    static var previews: some View {
        selectFromCategory(categoryInd: .constant(0), categoryList: []).environmentObject(models())
    }
}
