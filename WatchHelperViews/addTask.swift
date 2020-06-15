//
//  addTask.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/13/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct addTask: View {
    @State var activeView:Binding<Bool>
    @EnvironmentObject var data:models
    @State var task:models.task = models.task(id: 0, name: "", description: "", category:  models.category("Work"))
    
    
    func addTaskToList(task: models.task)
    {
            let len = self.data.taskData.count
            var taskLocal = task
            taskLocal.id = len
        if self.task.name != ""
        {
            self.data.taskData.append(taskLocal)
            self.task = models.task(id: 0, name: "", description: "", category: models.category("Work"))
        }
    }
    
    var body: some View {
  
           
                ScrollView
                    {
                        
                        TextField("Name", text: $task.name)
                

                        Picker(selection: $task.category, label: Text("Category")) {
                            ForEach(data.categories,id: \.self)
                            {
                                category in
                                Text(category.name).tag(category)
                                    .accentColor(category.color)
                            }

                        }.frame(height:100)

                        
                Button(action:
                    {
                        self.addTaskToList(task: self.task)
                        self.activeView.wrappedValue = false
                }) {
                    Text("Add")
                }
                        
                }
    .navigationBarTitle("Add task")
         
    }
            
        }
        

struct addTask_Previews: PreviewProvider {
    static var previews: some View {
        addTask(activeView: .constant(false)).environmentObject(models())
    }
}
