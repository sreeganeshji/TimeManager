//
//  selectFromColors.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct selectFromColors: View {
    @EnvironmentObject var data:models
    @Binding var colorVal:Color
    @State var colorValLocal:Color = .blue
    func updatePicker()->String{
        self.colorVal = self.colorValLocal
        return "Color select"
    }
    var colors:[Color]
    var body: some View {
        Picker( selection: self.$colorVal,label: Text("colorPicker")) {
                                    ForEach(self.colors,id: \.self)
                                    {
                                        color in
                                        HStack{
                                            
                                            Image(systemName:"bookmark.fill").foregroundColor(color)
                                            Text(self.data.getColorName(color))
                                            Spacer()
                                        }
                                            .tag(color)
                        
        //                            .padding()
                                    }
                                }
                            .labelsHidden()
    .onAppear()
        {
            self.colorValLocal = self.colorVal
        }
        .onDisappear(){
            self.updatePicker()
        }
    }
}

struct selectFromColors_Previews: PreviewProvider {
    static var previews: some View {
        selectFromColors(colorVal: .constant(.red), colors: []).environmentObject(models())
    }
}
