//
//  Summary2iOS.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/29/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct Summary2iOS: View {
    @State var summaryDaemon:SummaryDaemon
    @State var taskList:[models.task]
    @State var categoryList:[models.category]
    @State var timeFrame:Calendar.Component = .day
    @State var showTaskvsCategory = true
    @EnvironmentObject var data:models
    @State var selectedDate:Date = .init()
    @State var count = 0
    let today:String
    
//    let timer = Timer.publish(every: 1.0/4.0, on: .main  , in: .common).autoconnect()
    
    var format:DateFormatter = .init()
    
       // increment the activated task times based on the timer.
        func incrementTaskCounter(task:Binding< models.task>)
        {
            /*
            If the task is selected, increment its counter
             */
            let originalTaskname = task.wrappedValue.name
                let interval = task.wrappedValue.timestamp[self.today]
                /*
                 Check if the timer was changed recently.
                 
                 */
                let lastChangedDate = Date(timeIntervalSince1970: task.wrappedValue.lastChanged ?? Date().timeIntervalSince1970)
    //        print(lastChangedDate.timeIntervalSince1970)
            let newTaskname = task.wrappedValue.name
            if(originalTaskname != newTaskname)
            {
                print("Task changed from \(originalTaskname) to \(newTaskname)")
            }
                let duration = DateInterval(start: lastChangedDate, end: Date()).duration.magnitude
                
                task.wrappedValue.lastChanged = Date().timeIntervalSince1970
                if duration > 1.50
                {
                    task.wrappedValue.timestamp[self.today] = TimeInterval(interval!.advanced(by: Double(Int(duration))))
                }
                else{
                task.wrappedValue.timestamp[self.today] = TimeInterval(interval!.advanced(by: 1))
                }
            
            
        }
    
    
    var body: some View {
        
    //        NavigationView{
                VStack{
                  
                    Picker(selection: self.$data.summaryInterval, label: Text("Interval")) {
                    Text("Day").tag(Calendar.Component.day)
                    Text("Week").tag(Calendar.Component.weekOfYear)
                    Text("Month").tag(Calendar.Component.month)
                    Text("Year").tag(Calendar.Component.year)
                }
                    .pickerStyle(SegmentedPickerStyle())
   

                    VStack{
                        if(self.taskList.count == 0)
                                {
                                    Spacer()
                                }
               
        else{
                if(self.showTaskvsCategory)
                {
                    taskSummary2iOS(taskRecordArr: self.$summaryDaemon.taskRecordArr, categoryList: self.categoryList).environmentObject(self.data)

                }
            else{
                    categorySummary2iOS(categoryList: self.categoryList, catRecordArr: self.summaryDaemon.catRecordArr).environmentObject(self.data)

                }
            }
        }
        
                    selectRange(dateField: self.$data.summaryInterval, dateValue: self.$data.summaryDate).environmentObject(self.data)

                        Picker(selection: self.$showTaskvsCategory, label:Text("Choice"))
                        {
                            
                            Text("Task").tag(true)
                            Text("Category").tag(false)
                        }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    }
                
        .navigationBarTitle("Summary")

    //        }
            .onAppear()
                {
                    self.format.dateFormat = "MM_dd_yyyy"
            }
        
//                .onReceive(self.timer){
//                    time in
////                    print("receiving here")
////                    print(time)
//
//
//                    if(self.count == 4)
//                    {
//                        self.count = 0
//                    for ind in 0...self.taskList.count-1
//                    {
//                      if self.taskList[ind].selected{
//                        self.incrementTaskCounter(task: self.$taskList[ind])
//                      }
//                    }
//                    }
//
//                    self.count += 1
//
//                    self.summaryDaemon.taskArr = self.taskList
//                    self.summaryDaemon.categoryList = self.categoryList
//                    self.summaryDaemon.update(dateComponent:self.timeFrame, startDate: self.selectedDate)
//
//        }
        
        }
}

struct Summary2iOS_Previews: PreviewProvider {
    static var previews: some View {
        Summary2iOS(summaryDaemon: .init(), taskList: [], categoryList: [],today:"someDate")
    }
}
