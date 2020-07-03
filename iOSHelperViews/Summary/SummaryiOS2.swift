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
    @State var showSheet = false
    @State var ShowTaskvsCategory:Bool
    @State var interval:Calendar.Component = .day

    
    func updateInterval()->String{
        self.data.summaryTimeRange = self.interval
        return "Interval"
    }

    func updateTaskvsCat()->String{
        self.data.showTaskvsCategory = self.ShowTaskvsCategory
        return "taskvscat"
    }
    
    var body: some View {
    

            VStack{

//                List{
                    PickerTimeRange(summaryTimeRange: self.$interval,label:updateInterval())

                    summaryBody(data: self._data, ShowTaskvsCategory: self.$ShowTaskvsCategory)
//                }
                selectRange(dateField: self.$data.summaryTimeRange, dateValue: self.$data.refDate).environmentObject(self.data)

                    Picker(selection: self.$ShowTaskvsCategory, label:Text(updateTaskvsCat()))
                    {
                        
                        Text("Task").tag(true)
                        Text("Category").tag(false)
                    }
                .pickerStyle(SegmentedPickerStyle())
                
                }
            
    .navigationBarTitle("Summary")

        
        .onAppear()
            {
                self.format.dateFormat = "MM_dd_yyyy"
                print("initialized summary view")
                self.data.calculateSummary = true
                self.ShowTaskvsCategory = self.data.showTaskvsCategory
        }
        .onDisappear(){
            self.data.calculateSummary = false
        }
    }
}

struct SummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        SummaryiOS(ShowTaskvsCategory: true).environmentObject(models())
    }
}
