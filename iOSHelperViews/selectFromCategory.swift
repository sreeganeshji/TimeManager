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
    @State var categoryIndLocal:Int = 0
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

    func updatePicker()->String{
        self.categoryInd = self.categoryIndLocal
        return "Category select"
    }
    
    var body: some View {
           Picker( selection: self.$categoryIndLocal,label: Text(updatePicker())) {
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
           .onAppear(){
            self.categoryIndLocal = self.categoryInd
        }
    }
}

struct selectFromCategory_Previews: PreviewProvider {
    static var previews: some View {
        selectFromCategory(categoryInd: .constant(0), categoryList: []).environmentObject(models())
    }
}
