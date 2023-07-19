//
//  OrganizationPage.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 7/13/23.
//

import SwiftUI

struct OrganizationPage: View {
    @EnvironmentObject var manager : AppManager
    var body: some View {
        NavigationStack
        {
            VStack
            {
                if manager.organization == Organization.empty
                {
                    Text("Organization")
                        .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                        .foregroundColor(Color.black)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image("pngwing.com")
                        .resizable()
                        .padding(.vertical)
                        .scaledToFit()
                        .frame(width: 180, height: 209)
                    Text("Join an organization to submit your hours or create your own!")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("SF-Pro-Display-Bold", size: 20))
                        .padding(.top)
                    Spacer()
                    
                    //join button
                    NavigationLink {
                        JoinOrganizationPage()
                            .environmentObject(manager)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("darkgrey"))
                                .frame(width: 281, height: 65)
                            Text("Join")
                                .foregroundColor(Color.white)
                                .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                        }
                    }
                    //create button
                    NavigationLink {
                        CreateOrganizationPage()
                            .environmentObject(manager)
                        
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("darkgrey"))
                                .frame(width: 281, height: 65)
                            Text("Create")
                                .foregroundColor(Color.white)
                                .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                        }
                    }
                    .padding(.top)
                }
                else
                {
                    if (manager.account.isOwner)
                    {
                        ForEach( manager.organization.users,  id: \.self) { user in RoundedRectangle(cornerRadius: 30)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct OrganizationPage_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationPage()
            .environmentObject(AppManager())
    }
}
