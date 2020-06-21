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
    @State var task:models.task = models.task(id: 0, name: "", description: "", category:  models().categories[1])
    
    
    func addTaskToList(task: models.task)
    {
            let len = self.data.taskData.count
            var taskLocal = task
            taskLocal.id = len
        if self.task.name != ""
        {
            self.data.taskData.append(taskLocal)
            self.task = models.task(id: 0, name: "", description: "", category: models().categories[1])
        }
    }
    
    var body: some View {
        NavigationView{
           
                List
                    {
                        
                        TextField("Name", text: $task.name)
                

                    
                        Picker( selection: $task.category,label: Text("Category")) {
                            ForEach(data.categories,id: \.self)
                            {
                                category in
                                HStack{
                                    Image(systemName:"bookmark.fill").foregroundColor(category.color)
                                   
                                Text(category.name).tag(category)
                                    Spacer()
                                }.tag(category)
//                            .padding()
                            }

                        }
                    .labelsHidden()
//                        .tabItem({Text("Stuff")})
                        TextField("Description",text: $task.description)
                        
                }
    .padding()
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
        }
        

struct addTaskiOS_Previews: PreviewProvider {
    static var previews: some View {
        addTaskiOS(activeView: .constant(false)).environmentObject(models())
    }
}
