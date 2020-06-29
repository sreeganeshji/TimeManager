//
//  chooseMonth.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/28/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct chooseMonth: View {
    @Binding var monthVal:Int
    @Binding var showSheet:Bool
    let MonthArr:[String] = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var body: some View {
        Picker(selection: self.$monthVal, label: Text("Month:"), content: {
            ForEach(1...self.MonthArr.count,id:\.self)
            {
                ind in
//                Text("\(ind)").tag(ind+1)
                Text(self.MonthArr[ind-1])
                    .tag(ind)
            }
        })
        .labelsHidden()
            .navigationBarTitle("Select month")
        .navigationBarItems(trailing: Button(action:{self.showSheet = false})
        {
            Text("Done")
        })
    }
}

struct chooseMonth_Previews: PreviewProvider {
    static var previews: some View {
        chooseMonth(monthVal: .constant(10),showSheet: .constant(false))
    }
}
