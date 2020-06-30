//
//  taskSummary.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/29/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskSummary: View {
    @EnvironmentObject var data:models
    
    func giveTime(time:Int)->String
     {
         var sec = time
         var min = sec/60
         var hr = min/60
        let days = hr/24
         sec %= 60
         min %= 60
        hr %= 24
        if (days>0)
        {
            return("\(days) days \(hr):\(min):\(sec)")
        }
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
       VStack{
           List{

           
               HStack  {
                   Text("Task").bold()
                   Spacer()
                   Text("Time").bold()
                       }
                                       
                                       
           ForEach(self.data.taskRecordArr.indices,id:\.self)
                   {
           ind in
        
           HStack      {
               Rectangle().frame(width:20)
                   .foregroundColor((self.data.taskData.count > ind) ? self.data.getColor(self.data.categories[self.data.taskRecordArr[ind].task.categoryInd].color) : .gray)
               Text((self.data.taskData.count > ind) ? self.data.taskRecordArr[ind].task.name : "Deleted")
               Spacer()
               Text(self.giveTime(time: (self.data.taskData.count > ind) ? Int(self.data.taskRecordArr[ind].time) : 0))
                       }
                   }
               }
           }
    }
}

struct taskSummary_Previews: PreviewProvider {
    static var previews: some View {
        taskSummary().environmentObject(models())
    }
}
