//
//  taskRecords.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskRecords: View {
    let taskInd:Int
    let summayDaemon:SummaryDaemon = .init()
    
    var format : DateFormatter
    
    let calendar = Calendar.autoupdatingCurrent
    
    @EnvironmentObject var data:models
    
    struct taskRecordHistory:Hashable{
        let date:Date
        let time:TimeInterval
    }
    
    init(taskInd:Int,formatString:String)
    {
        self.taskInd = taskInd
        self.format = .init()
        self.format.dateFormat = "MM_dd_yyyy"
    }
    
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
    
    var taskRecordHistoryArr:[taskRecordHistory]{
        var res:[taskRecordHistory] = []
        for (key,value) in self.data.taskData[self.taskInd].timestamp{
            res.append(.init(date: format.date(from: key) ?? .init(), time: value))
        }
        
        res.sort { (taskRecordHistory1, taskRecordHistory2) -> Bool in
            return(taskRecordHistory1.date > taskRecordHistory2.date)
        }
        
        return res
    }
    
    func getMonth(_ date:Date)->String{
        let month = calendar.dateComponents([.month], from: date)
        return monthDict[month.month!]!
    }
       var monthDict:[Int:String] = [1:"January",2:"Feburary",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"]
    
    func getDate(_ date:Date)->String{
        let date = calendar.dateComponents([.day], from: date)
        return String(date.day!)
    }
    
    func getYear(_ date:Date)->String{
         let week = calendar.dateComponents([.year], from: date)
         return String(week.year!)
     }
    
    var body: some View {

        List{
            ForEach(self.taskRecordHistoryArr,id:\.self)
            {
                record in
//                Text("\(record.date.description), \(giveTime(record.time))")
                HStack{
                Text(self.getMonth(record.date))
                Text(self.getDate(record.date))
                Text(self.getYear(record.date))
                    Spacer()
                    Text(self.giveTime(time: Int(record.time)))
                }
            .padding()
                
            }
        .onDelete(perform: {
            indexSet in
            for ind in indexSet{
//                print(self.taskRecordHistoryArr[ind].date.description)
                self.data.taskData[self.taskInd].timestamp.removeValue(forKey: self.format.string(from: self.taskRecordHistoryArr[ind].date))
            }
        })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("\(self.data.taskData[self.taskInd].name)")
    .navigationBarItems(trailing: EditButton())
   
        .onAppear(){
//            self.format.dateFormat = "MM_dd_yyyy"
        }
    }
}

struct taskRecords_Previews: PreviewProvider {
    static var previews: some View {
        taskRecords(taskInd: 0, formatString: "").environmentObject(models())
    }
}
