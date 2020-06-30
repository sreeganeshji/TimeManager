//
//  taskSummary2.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/29/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskSummary2iOS: View {
    @Binding var taskRecordArr:[SummaryDaemon.taskRecord]
    @EnvironmentObject var data:models
    var categoryList:[models.category]
    
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

    var body: some View {
       List{
           HStack  {
               Text("Task").bold()
               Spacer()
               Text("Time").bold()
                   }
                                   
                                   
       ForEach(self.taskRecordArr.indices,id:\.self)
               {
       ind in
    
       HStack      {
           Rectangle().frame(width:20)
            .foregroundColor(self.data.getColor(self.categoryList[self.taskRecordArr[ind].task.categoryInd].color))
        Text( self.taskRecordArr[ind].task.name )
           Spacer()
           Text(self.giveTime(time: Int(self.taskRecordArr[ind].time)))
                   }
               }
           }
       }
}

struct taskSummary2iOS_Previews: PreviewProvider {
    static var previews: some View {
        taskSummary2iOS(taskRecordArr: .constant([]), categoryList: [])
    }
}
