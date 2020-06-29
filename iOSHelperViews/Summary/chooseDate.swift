//
//  chooseDate.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/27/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct chooseDate: View {
    @Binding var dateVal:Date
    @Binding var showSheet:Bool
    var body: some View {
        
        DatePicker(selection: self.$dateVal, displayedComponents: .date, label: { Text("Date") })
        .labelsHidden()
        .navigationBarTitle("Select day")
            .navigationBarItems(trailing: Button(action:{self.showSheet = false})
            {
                Text("Done")
            })
    }
}

struct chooseDate_Previews: PreviewProvider {
    static var previews: some View {
        chooseDate(dateVal: .constant(.init()),showSheet: .constant(false))
    }
}
