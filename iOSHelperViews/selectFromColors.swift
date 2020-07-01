//
//  selectFromColors.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct selectFromColors: View {
    @Binding var colorVal:Color
    var colors:[Color]
    var body: some View {
        Picker( selection: self.$colorVal,label: Text("Color")) {
                                    ForEach(self.colors,id: \.self)
                                    {
                                        color in
                                        HStack{
                                            Image(systemName:"bookmark.fill").foregroundColor(color)
                                            Text(color.description)
                                            Spacer()
                                        }
                                            .tag(color)
                        
        //                            .padding()
                                    }
                                }
                            .labelsHidden()
    }
}

struct selectFromColors_Previews: PreviewProvider {
    static var previews: some View {
        selectFromColors(colorVal: .constant(.red), colors: [])
    }
}
