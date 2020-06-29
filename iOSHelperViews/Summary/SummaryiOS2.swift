//
//  SummaryiOS.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/21/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//
/*
 Need to represent the progress of the tasks and categories for daily, weekly, monthly and yearly basis for all the time.
 */

import SwiftUI


struct SummaryiOS: View {
    
    var format = DateFormatter()
    @EnvironmentObject var data:models
    @State var selection = 0
  
    @State var ShowTaskvsCategory = true

    
//    func updateSummaryAndGiveInterval()->String
//    {
//        self.data.sumaryRecord.taskArr = self.data.taskData
//        self.data.sumaryRecord.categoryList = self.data.categories
//        self.data.sumaryRecord.update(dateComponent: self.data.summaryTimeRange, startDate: self.data.refDate)
//        self.data.taskRecordArr = self.data.sumaryRecord.taskRecordArr
//        self.data.catRecordArr = self.data.sumaryRecord.catRecordArr
//        return ("Interval")
//    }
    
    var body: some View {
    
//        NavigationView{
            VStack{
              
                Picker(selection: self.$data.summaryTimeRange, label: Text("Interval")) {
                Text("Day").tag(Calendar.Component.day)
                Text("Week").tag(Calendar.Component.weekOfYear)
                Text("Month").tag(Calendar.Component.month)
                Text("Year").tag(Calendar.Component.year)
            }
                .pickerStyle(SegmentedPickerStyle())

        
//            .onReceive([self.calComponent].publisher.first(), perform: { value in
//                .onReceive(self.timer4){ _ in
//                print("updating View")
//                self.summaryRecord.taskArr = self.data.taskData
//                self.summaryRecord.categoryList = self.data.categories
//                self.summaryRecord.update(dateComponent: self.calComponent, startDate: Date())}
           
                 

                VStack{
                    if(self.data.taskRecordArr.count == 0)
                            {
                                Spacer()
                            }
           
    else{
            if(self.ShowTaskvsCategory)
            {
                taskSummary().environmentObject(self.data)

            }
        else{
                categorySummary().environmentObject(self.data)

            }
        }
    }
    
                selectRange(dateField: self.$data.summaryTimeRange, dateValue: self.$data.refDate).environmentObject(self.data)

                    Picker(selection: self.$ShowTaskvsCategory, label:Text("Choice"))
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

                self.data.calculateSummary = true
        }
        .onDisappear(){
            self.data.calculateSummary = false
        }
    }
}

struct SummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        SummaryiOS().environmentObject(models())
    }
}
