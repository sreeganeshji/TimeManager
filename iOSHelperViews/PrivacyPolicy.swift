//
//  PrivacyPolicy.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/7/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        VStack(){
            Text("Privacy policy").font(.title)
            Divider()
            Text("This policy applies to all information collected on our iphone apps.\nInformation we collect: \nTime Tally does not collect any data from the app. \nAll the app data are stored locally.\nChanges to this policy: \nIf we decide to change our privacy policy as we add new features, we will post those changes on this page. \nSummary: \nJuly 7th 2020: First published.")
            Divider()
            Text("This information can be found at")
            Text("http://projmgrtool.com/timetally/privacy")
            Spacer()
         
        }
        .padding(.horizontal)
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}
