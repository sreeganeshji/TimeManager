//
//  TaskSummary.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct TaskSummaryiOS: View {
    var taskInd:Int
    
    @State var today:String = ""
    var format = DateFormatter()
    var displayFormat = DateFormatter()
    @EnvironmentObject var data:models
    
    
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
     
     func reset()
     {
        self.data.taskData[self.taskInd].timestamp[self.today] = TimeInterval(0)
     }
    var body: some View {
        List{
                  HStack{
                    Text("Category:").bold()
                   
                      Spacer()
                      Text("\(self.data.taskData[self.taskInd].category.name)").foregroundColor(self.data.taskData[self.taskInd].category.color)
                  }
               
                   HStack{
                       Text("Today's time:").bold()
                    Spacer()
                       Text(giveTime(time: Int(self.data.taskData[self.taskInd].timestamp[self.today] ?? 0)))
                   Spacer()
                   Button(action: {self.reset()})
                   {
                       Text("Reset")
                   }
            }
            
            HStack{
                Text("Description").bold()
                Spacer()
                Text(self.data.taskData[self.taskInd].description)
            }
            
//                   Divider()
        }
    .onAppear()
        {
    
             self.format.dateFormat = "MM_dd_yyyy"
            self.today = self.format.string(from: Date())
             self.displayFormat.dateFormat = "hh:MM:ss"
        }
    }
}

struct TaskSummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        TaskSummaryiOS(taskInd: 0).environmentObject(models())
    }
}
