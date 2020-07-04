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
    @State var showSheet = false
    @State var showDetail = false
    @State var selectedCat = 0
    
    var body: some View {
//        NavigationView{
        List {
            if(self.data.categories.count > 1)
            {
            ForEach(1...self.data.categories.count-1, id: \.self)
            {
                catInd in
//                NavigationLink(destination: CategoryDetail(category: self.$data.categories[catInd]).environmentObject(self.data))
//                {
                Button(action:{self.showDetail = true
                    self.showDetail = true
                    self.selectedCat = catInd
                    self.showSheet = true
                }){
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
                
//            }
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
                    else if(self.data.taskData[taskInd].categoryInd > i+1)
                    {
                        self.data.taskData[taskInd].categoryInd -= 1
                    }
                }
                  self.data.categories.remove(at: i+1)
            }
        })
        }
        }
        .navigationBarTitle("Categories")
            .navigationBarItems(leading: EditButton(), trailing:
                
//                NavigationLink(destination: addCategoryiOS(activeView: self.$showAddCategoryView).environmentObject(self.data))
//                {
//                   Image(systemName: "square.and.pencil")
//                }
//            )
                Button(action:{
                    self.showDetail = false
                    self.showSheet = true
                }){ Image(systemName: "square.and.pencil")})
       
        
        .sheet(isPresented: self.$showSheet, content: {
            if(!self.showDetail){
            NavigationView{
            addCategoryiOS(activeView: self.$showSheet).environmentObject(self.data)
            }
            }
            else{
                NavigationView{
                    CategoryDetail(category: self.$data.categories[self.selectedCat], showSheet: self.$showSheet).environmentObject(self.data)
                }
            }
            
        })
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList().environmentObject(models())
    }
}
