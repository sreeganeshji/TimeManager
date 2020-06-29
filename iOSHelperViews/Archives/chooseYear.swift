//
//  chooseYear.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/28/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct chooseYear: View {
    @Binding var showSheet:Bool
    @Binding var year:Int
    var body: some View {
        Picker(selection: self.$year, label: Text("Year:"), content: {
            ForEach(1000...3000,id:\.self, content: {
                ind in
                Text(String(ind)).tag(ind)
            })
        })
        .labelsHidden()
        .navigationBarTitle("Select month")
        .navigationBarItems(trailing: Button(action:{self.showSheet = false})
        {
            Text("Done")
        })
    }
}

struct chooseYear_Previews: PreviewProvider {
    static var previews: some View {
        chooseYear(showSheet: .constant(false), year: .constant(2010))
    }
}
