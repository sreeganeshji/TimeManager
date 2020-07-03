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
    @EnvironmentObject var data:models
  

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
                                            Image(systemName:"bookmark.fill").foregroundColor(self.data.getColor(self.categoryList[ind].color))
                                           
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
