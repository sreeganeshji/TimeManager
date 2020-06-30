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
    @State var ShowTaskvsCategory = true
    var timeFrame:String{
        switch self.data.summaryTimeRange {
        case .day:
            return "Day"
        case .weekOfYear:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        default:
            return "Day"
        }
    }
    

    
    var body: some View {
    

            VStack{

                Form{
                Picker(selection: self.$data.summaryTimeRange, label: Text("Time interval")) {
                Text("Day").tag(Calendar.Component.day)
                Text("Week").tag(Calendar.Component.weekOfYear)
                Text("Month").tag(Calendar.Component.month)
                Text("Year").tag(Calendar.Component.year)

                }


                Section{
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
