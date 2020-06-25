//
//  TaskEdit.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct TaskEdit: View {
    @EnvironmentObject var data:models
    let taskInd:Int
    @State var defaultTask : models.task = models.task(myId: 10, name: "Default", description: "Default")

    @State var today:String = ""
    @State var timeText:String = ""
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
       
            VStack{
                HStack{
                    Text("Name")
//                    TextField("", text: self.$defaultTask.name)
//                    TextField("Text Field", text: $today)
                }
//               Divider()
//
//                HStack
//                    {
//                        Text("Time")
//                        Spacer()
//                        TextField(self.giveTime(time: Int(self.defaultTask.timestamp[self.today] ?? 0)), text: self.$timeText)
//                }
//
//                Divider()
//                Text("Category")
//
//                Picker(selection: self.$defaultTask.category, label: Text("")) {
//                    ForEach(self.data.categories,id:\.self)
//                    {
//                        category in
//
//                                Text(category.name)
//                                    .foregroundColor(category.color)
//                        .tag(category)
//                    }
//
//                    }.frame(height:100)
//
//                Text("Description")
//                TextField("", text: self.$defaultTask.description)
//
//                Button(action: {self.saveTask()}) {
//                    Text("Button")
//                }
            }
//    .onAppear()
//        {
//            if (self.defaultTask.name == "Default")
//            {
//            self.defaultTask = self.data.taskData[self.taskInd]
//            }
//            self.format.dateFormat = "MM_dd_yyyy"
//            self.today = self.format.string(from: Date())
//        }
    }
}

struct TaskEdit_Previews: PreviewProvider {

    static var previews: some View {
        TaskEdit(taskInd: 0)
        .environmentObject(models())
        
    }
}
