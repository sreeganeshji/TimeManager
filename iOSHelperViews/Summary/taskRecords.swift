//
//  taskRecords.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskRecords: View {
    @Binding var showSheet:Bool
    let letChangeTime:Bool
    let taskInd:Int
    let summayDaemon:SummaryDaemon = .init()
    
    var format : DateFormatter
    
    let calendar = Calendar.autoupdatingCurrent
    
    @EnvironmentObject var data:models
    
    @State var timeRecords:[String:TimeInterval] = .init()
    
    struct taskRecordHistory:Hashable{
        let date:Date
        let time:TimeInterval
    }
    
    init(taskInd:Int,showSheet:Binding<Bool>,letChangeTime:Bool)
    {
        self.taskInd = taskInd
        self.format = .init()
        self.format.dateFormat = "MM_dd_yyyy"
        self._showSheet = showSheet
        self.letChangeTime = letChangeTime
        print("taskRecords init")
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
            if(value != 0){
            res.append(.init(date: format.date(from: key) ?? .init(), time: value))
            }
            
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
            if(self.letChangeTime){
                
            ForEach(self.taskRecordHistoryArr,id:\.self)
            {
                taskRecord in
//                Text("\(record.date.description), \(giveTime(record.time))")
                NavigationLink(destination:selectHours(showSheet: self.$showSheet, dateString: self.format.string(from: taskRecord.date), dateDisplayString: "\(self.getMonth(taskRecord.date)) \(self.getDate(taskRecord.date)) \(self.getYear(taskRecord.date))", taskInd: self.taskInd).environmentObject(self.data)
                    .onAppear()
                        {
//                            print("going to change time view")
                            self.data.pauseTasksAndSummary()
                            self.data.taskData[self.taskInd].lastChanged = nil
                            
                }
                .onDisappear()
                    {
                        self.data.resumeTasksAndSummary()
                }
                    .padding()
                ){
                HStack{
                    if(taskRecord.date == self.format.date(from: self.format.string(from: .init())))
                    {
                        Text("Today")
                    }
                    else{
                    Text(self.getMonth(taskRecord.date))
                    Text(self.getDate(taskRecord.date))
                    Text(self.getYear(taskRecord.date))
                    }
                    Spacer()
                   
                    Text(self.giveTime(time: Int(taskRecord.time)))
                    }
                 }
            .padding()
//                .disabled((taskRecord.date == self.format.date(from: self.format.string(from: .init()))) && self.data.taskData[self.taskInd].selected)
//            .deleteDisabled((taskRecord.date == self.format.date(from: self.format.string(from: .init()))) && self.data.taskData[self.taskInd].selected)
                
            }
        .onDelete(perform: {
            indexSet in
            for ind in indexSet{
//                print(self.taskRecordHistoryArr[ind].date.description)
                self.data.taskData[self.taskInd].timestamp.removeValue(forKey: self.format.string(from: self.taskRecordHistoryArr[ind].date))
                self.data.taskData[self.taskInd].selected = false
//                self.timeRecords.removeValue(forKey: self.format.string(from: self.taskRecordHistoryArr[ind].date))
            }
        })
                
            }
            else{
                ForEach(self.taskRecordHistoryArr,id:\.self)
                           {
                            taskRecord in
                            HStack{
                                               if(taskRecord.date == self.format.date(from: self.format.string(from: .init())))
                                               {
                                                   Text("Today")
                                               }
                                               else{
                                               Text(self.getMonth(taskRecord.date))
                                               Text(self.getDate(taskRecord.date))
                                               Text(self.getYear(taskRecord.date))
                                               }
                                               Spacer()
                                              
                                               Text(self.giveTime(time: Int(taskRecord.time)))
                                               }
            }
                
                        .onDelete(perform: {
                            indexSet in
                            for ind in indexSet{
                //                print(self.taskRecordHistoryArr[ind].date.description)
                                self.data.taskData[self.taskInd].timestamp.removeValue(forKey: self.format.string(from: self.taskRecordHistoryArr[ind].date))
                                self.data.taskData[self.taskInd].selected = false
                //                self.timeRecords.removeValue(forKey: self.format.string(from: self.taskRecordHistoryArr[ind].date))
                            }
                        })

            }
        
        
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("\(self.data.taskData[self.taskInd].name)")
    .navigationBarItems(leading: EditButton())
        .navigationBarItems(trailing: Button(action:{
            self.showSheet = false
        })
        {
            Text("Done")
        })
   
        .onAppear(){
//            self.format.dateFormat = "MM_dd_yyyy"
//            self.timeRecords = self.data.taskData[self.taskInd].timestamp
        }
    }
}

struct taskRecords_Previews: PreviewProvider {
    static var previews: some View {
        taskRecords(taskInd: 0,showSheet: .constant(false), letChangeTime: true).environmentObject(models())
    }
}
