//
//  CategoryList.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/15/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct CategoryList: View {
@EnvironmentObject var data:models
    @State var showAddCategoryView = false
    
    var body: some View {
//        NavigationView{
        List {
            if(self.data.categories.count > 1)
            {
            ForEach(1...self.data.categories.count-1, id: \.self)
            {
                catInd in
                NavigationLink(destination: CategoryDetail(category: self.$data.categories[catInd]).environmentObject(self.data))
                {
                    HStack{
                    Text(self.data.categories[catInd].name)
                        Spacer()
//                        RoundedRectangle(cornerRadius: 5)
//                            .frame(width:30)
//                            .foregroundColor(self.data.categories[catInd].color)
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(self.data.getColor(self.data.categories[catInd].color))
                    }
                }
                
            }
        .onDelete(perform: {
            index in
            for i in index{
//                print("Index is \(i), category is \(self.data.categories[i])")
              
                //change the task categories to 0 when deleted
                for taskInd in self.data.taskData.indices
                {
                    if(self.data.taskData[taskInd].categoryInd == i+1)
                    {
                        self.data.taskData[taskInd].categoryInd  = 0
                    }
                }
                  self.data.categories.remove(at: i+1)
            }
        })
        }
        }
        .navigationBarTitle("Categories")
            .navigationBarItems(leading: EditButton(), trailing: Button(action:{self.showAddCategoryView = true}){ Image(systemName: "square.and.pencil")})
       
//        }
        .sheet(isPresented: self.$showAddCategoryView, content: {
            addCategoryiOS(activeView: self.$showAddCategoryView).environmentObject(self.data)
            
        })
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList().environmentObject(models())
    }
}
