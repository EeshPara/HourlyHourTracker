//
//  CreateOrganizationPage.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 7/13/23.
//

import SwiftUI

struct CreateOrganizationPage: View {
    @EnvironmentObject var manager : AppManager
        var body: some View {
                NavigationStack{
                    VStack{
                        //logo
                        Text("Create an Organization")
                            .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                            .foregroundColor(Color.black)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        TextField("Name", text: $manager.organization.name)
                            .padding()
                            .autocapitalization(.none)
                            .font(
                                .custom("SF-Pro-Display-Bold", size: 24))
                            .foregroundColor(Color(.black))
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            )
                            .frame(width: 308, height: 75)
                        TextField("Description", text: $manager.organization.description)
                            .padding()
                            .autocapitalization(.none)
                            .font(
                                .custom("SF-Pro-Display-Bold", size: 24))
                            .foregroundColor(Color(.black))
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            )
                            .frame(width: 308, height: 75)
                        
                        //subheading
                        Spacer()
                        
                        //signup button
                        Button {
                           createOrganization()
                            signUpUser()
                            //toggle navigation
                            
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
                        .disabled(manager.organization.name.isEmpty)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(0.0)
                }
                .padding(50)
            }
    func createOrganization(){
        // sets the user account to admin and owner of org
        manager.account.isAdmin = true
        manager.account.isOwner = true
        // setting the owner of the org to the current account
        var org = manager.organization
        org.owner = manager.account
        // creating org
        manager.db.createOrganization(org: org)
        // making the users org the current org now that the org is created
        manager.account.organizationName = manager.organization.name
    }
    func signUpUser(){
      // just signing up the current user now
        manager.db.signUpUser(user: manager.account)
    }
    
}

struct CreateOrganizationPage_Previews: PreviewProvider {
    static var previews: some View {
        CreateOrganizationPage()
            .environmentObject(AppManager())
    }
}
