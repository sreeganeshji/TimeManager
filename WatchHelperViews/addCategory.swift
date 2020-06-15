//
//  addCategory.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/18/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct addCategory: View {
    @State var newCategory:String = ""
    @EnvironmentObject var data:models
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct addCategory_Previews: PreviewProvider {
    static var previews: some View {
        addCategory()
    }
}
