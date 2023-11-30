//
//  OrgOwnerTabView.swift
//  HourlyHourTracker
//
//  Created by Rohan Doshi on 7/22/23.
//

import SwiftUI



// Page that contains everything within it
// This is used for toolbar navigation between views
struct OrgOwnerTabView: View {
    @EnvironmentObject var manager: AppManager
    var body: some View {
        TabView{
            OrgOwnerPage()
                .environmentObject(manager)
                .tabItem {
                    Label("Owner", systemImage: "gear")
                }
            
            AdminPage()
                .tabItem {
                    Label("Admin", systemImage: "person.3")
                }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}


struct OrgOwnerTabView_Previews: PreviewProvider {
    static var previews: some View {
        OrgOwnerTabView()
            .environmentObject(AppManager())
    }
}
