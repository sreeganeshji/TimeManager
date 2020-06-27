//
//  TaskList.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct TaskList: View {
    @EnvironmentObject var data:models
    @State var addTaskRequest = false
    var body: some View {
        NavigationView{
        List{
            ForEach(self.data.taskData.indices,id:\.self)
            {
                taskInd in
                
                NavigationLink(destination: TaskSummaryiOS(taskInd:taskInd,showSheet: .constant(true) ).environmentObject(self.data))
                {
                    Text(self.data.taskData[taskInd].name)
                }
            }
            .onDelete { indSet in
                for ind in indSet{
                    self.data.taskData.remove(at: ind)
                }
            }
            .onMove { (indSet, ind) in
                self.data.taskData.move(fromOffsets: indSet, toOffset: ind)
            }
        }
      
            .navigationBarTitle("Tasks")
        .navigationBarItems(leading:EditButton(),trailing: Button(action:{
                          self.addTaskRequest = true
                      })
                          {
                      Image(systemName: "square.and.pencil")
                      }
            )
    }
    .sheet(isPresented: $addTaskRequest, content: {
        addTaskiOS(activeView: self.$addTaskRequest).environmentObject(self.data)
    })
    
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList().environmentObject(models())
    }
}
