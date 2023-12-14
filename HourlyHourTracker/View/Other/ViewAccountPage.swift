//
//  ViewAccountPage.swift
//  HourlyHourTracker
//
//  Created by Laksh Gulati on 12/13/23.
//

import SwiftUI

struct ViewAccountPage: View {
    
    @EnvironmentObject var manager : AppManager
    
    var body: some View {
        //photo code
        
        VStack {
            textDivider(text: "User Information")
            
            //name
            HStack{
                Text("Name")
                    .foregroundColor(.gray)
                Spacer()
                Text(manager.account.name)
                    .foregroundColor(.black)
            }
            
            Divider()
            
            //email
            HStack{
                Text("Email")
                    .foregroundColor(.gray)
                Spacer()
                Text(manager.account.email)
                    .foregroundColor(.black)
            }
            Divider()
            
            //organization
            HStack{
                Text("Organization")
                    .foregroundColor(.gray)
                Spacer()
                Text(manager.account.organizationName)
                    .foregroundColor(.black)
            }
            
            
            textDivider(text: "wow")
        }
        .padding(20)
        
        
    }
    
    private func textDivider(text : String) -> some View
    {
        HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
            Text(text)
                .font(.system(size: 12))
                .fontWeight(.bold)
                .lineLimit(1)
                    .padding(5)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                }
    }
    
}

struct ViewAccountPage_Previews: PreviewProvider {
    static var previews: some View {
        ViewAccountPage()
            .environmentObject(AppManager.testManager)
    }
}
