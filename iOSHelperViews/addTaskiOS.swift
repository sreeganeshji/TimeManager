//
//  addTask.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/13/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct addTaskiOS: View {
    @State var activeView:Binding<Bool>
    @EnvironmentObject var data:models
    @State var categoryInd :Int = 0
    @State var task:models.task = models.task(myId: 0, name: "", description: "")
    var categoryList:[models.category]
    
    func addTaskToList(task: models.task)
    {
            let len = self.data.taskData.count
            var taskLocal = task
            taskLocal.myId = len
            taskLocal.categoryInd = self.categoryInd
        if self.task.name != ""
        {
            self.data.taskData.append(taskLocal)
            self.task = models.task(myId: 0, name: "", description: "")
        }
    }
    
    var body: some View {
           
                List
                    {
                        
                        TextField("Name", text: $task.name)
                
//                        Picker(selection: self.$categoryInd, label:  HStack{Text("Category:").bold()
//
//                                  }) {
//
//                                      ForEach(self.data.categories.indices,id:\.self)
//                                      {
//                                          categoryInd in
//                                          HStack{
//                                              Image(systemName: "bookmark.fill").foregroundColor(self.data.getColor((self.data.categories[categoryInd].color)))
//                                              Text(self.data.categories[categoryInd].name)
//                                          }
//                                      .tag(categoryInd)
//                                      }
//
//                                  }
                        
                        selectFromCategory(categoryInd: self.$categoryInd, categoryList: self.categoryList).environmentObject(self.data)
                        .tabItem({Text("Stuff")})
//                        TextField("Description",text: $task.description)
                        
                }

        
//    .padding()
    .navigationBarTitle("Add task")
        .navigationBarItems(trailing:  Button(action:
                           {
                                self.addTaskToList(task: self.task)
                                self.activeView.wrappedValue = false
                       }) {
                           Text("Add")
                       })
        
    }
        }
        

struct addTaskiOS_Previews: PreviewProvider {
    static var previews: some View {
        addTaskiOS(activeView: .constant(false),categoryList: []).environmentObject(models())
    }
}
