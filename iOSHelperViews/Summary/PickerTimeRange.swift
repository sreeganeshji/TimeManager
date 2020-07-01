//
//  PickerTimeRange.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct PickerTimeRange: View {
    @Binding var summaryTimeRange:Calendar.Component
    var label:String
    var body: some View {
         Picker(selection: self.$summaryTimeRange, label: Text(label)) {
                     Text("Day").tag(Calendar.Component.day)
                     Text("Week").tag(Calendar.Component.weekOfYear)
                     Text("Month").tag(Calendar.Component.month)
                     Text("Year").tag(Calendar.Component.year)
                         
                     }

                     .pickerStyle(SegmentedPickerStyle())
    }
}

struct PickerTimeRange_Previews: PreviewProvider {
    static var previews: some View {
        PickerTimeRange(summaryTimeRange: .constant(.day),label:"Interval")
    }
}
