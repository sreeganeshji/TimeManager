//
//  chooseTimeInterval.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/30/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct chooseTimeInterval: View {
    @Binding var summaryTimeRange:Calendar.Component
    @Binding var showSheet:Bool
    @State var timeRange:Calendar.Component = .day
    var body: some View {
        NavigationView{
        Picker(selection: self.$timeRange, label: Text("Interval")) {
                       Text("Day").tag(Calendar.Component.day)
                       Text("Week").tag(Calendar.Component.weekOfYear)
                       Text("Month").tag(Calendar.Component.month)
                       Text("Year").tag(Calendar.Component.year)
                   }
    .labelsHidden()
    .navigationBarTitle("Choose time interval")
        .navigationBarItems(trailing: Button(action:{
            self.showSheet = false
            self.summaryTimeRange = self.timeRange
        })
        {
            Text("Done")
        })
            .onAppear(){
                self.timeRange = self.summaryTimeRange
            }
        }
    }
}

struct chooseTimeInterval_Previews: PreviewProvider {
    static var previews: some View {
        chooseTimeInterval(summaryTimeRange: .constant(.month),showSheet: .constant(true))
    }
}
