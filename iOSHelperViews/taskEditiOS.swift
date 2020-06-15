//
//  TaskEdit.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct TaskEditiOS: View {
    @EnvironmentObject var data:models
    let taskInd:Int
    @State var defaultTask : models.task = models.task(id: 10, name: "Default", description: "Default", category: .init("default"))

    @State var today:String = ""
    @State var timeText:String = ""
    @Binding var activeView:Bool
    let format = DateFormatter()
   
    func giveTime(time:Int)->String
        {
            var sec = time
            var min = sec/60
            let hr = min/60
            sec %= 60
            min %= 60
            if (hr>0){
                return ("\(hr):\(min):\(sec)")
            }
            else if(min>0)
            {
                return ("\(min):\(sec)")
            }
            
            return ("\(sec)")
        }

    
    func saveTask()
    {
        self.data.taskData[self.taskInd] = self.defaultTask
    }
    
    var body: some View {
       
            List{
                HStack{
                    Text("Name").bold()
                    Spacer()
                    TextField("", text: self.$defaultTask.name)
                }
                
//                HStack{
//
//                    TextField("", text: self.$defaultTask.name)
//                    Spacer()
//                    TextField("Text Field", text: $today)
//                }
           

                HStack
                    {
                        Text("Time").bold()
                        Spacer()
                        TextField(self.giveTime(time: Int(self.defaultTask.timestamp[self.today] ?? 0)), text: self.$timeText)
                }

                Picker(selection: self.$defaultTask.category, label: Text("Category").bold()) {
                    ForEach(self.data.categories,id:\.self)
                    {
                        category in

                                Text(category.name)
                                    .foregroundColor(category.color)
                        .tag(category)
                    }

                    }

                HStack{
                Text("Description").bold()
            Spacer()
                    TextField("", text: self.$defaultTask.description)

                }
            }

            
            
    .navigationBarTitle(self.defaultTask.name)
    .navigationBarItems(trailing:                 Button(action: {self.saveTask()
        self.activeView = false
    }) {
        Text("Done")
        
    })
    .onAppear()
        {
            if (self.defaultTask.name == "Default")
            {
            self.defaultTask = self.data.taskData[self.taskInd]
            }
            self.format.dateFormat = "MM_dd_yyyy"
            self.today = self.format.string(from: Date())
        }
    }
}

struct TaskEditiOS_Previews: PreviewProvider {

    static var previews: some View {
        TaskEditiOS(taskInd: 0, activeView: .constant(true))
        .environmentObject(models())
        
    }
}
