//
//  ContentView.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manager : AppManager = AppManager()
    var body: some View {
       WelcomePage()
            .environmentObject(manager)
       
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
