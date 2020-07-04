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
    @EnvironmentObject var data:models
  


    
    var body: some View {
           Picker( selection: self.$categoryInd,label: Text("categorySelect")) {
                                    ForEach(self.categoryList.indices,id: \.self)
                                    {
                                        ind in
                                        HStack{
                                            Image(systemName:"bookmark.fill").foregroundColor(self.data.getColor(self.categoryList[ind].color))
                                           
                                            Text(self.categoryList[ind].name)
//                                                .tag(ind)
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
