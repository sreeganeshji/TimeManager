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
        NavigationView{
        List {
            ForEach(data.categories.indices,id: \.self )
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
                            .foregroundColor(self.data.categories[catInd].color)
                    }
                }
                
            }
        .onDelete(perform: {
            index in
            for i in index{
//                print("Index is \(i), category is \(self.data.categories[i])")
                self.data.categories.remove(at: i)
            }
        })
        }
        .navigationBarTitle("Categories")
            .navigationBarItems(leading: EditButton(), trailing: Button(action:{self.showAddCategoryView = true}){ Image(systemName: "square.and.pencil")})
       
        }
        .sheet(isPresented: self.$showAddCategoryView, content: {addCategoryiOS(activeView: .constant(true)).environmentObject(self.data)})
    }
}

struct CategoryList_Previews: PreviewProvider {
    static var previews: some View {
        CategoryList().environmentObject(models())
    }
}
