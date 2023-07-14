//
//  JoinOrganizationPage.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 7/13/23.
//

import SwiftUI

struct JoinOrganizationPage: View {
    @EnvironmentObject var manager : AppManager
    @State private var organizations = [Organization]()
    @State private var navigate = false
    var body: some View {
        NavigationStack
        {
            VStack
            {
                Text("Join an Organization")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.top)
                HStack{
                    Menu("Organizations", content: {
                        ForEach(organizations){ organization in
                            Button(organization.name){
                                manager.account.organizationName = organization.name
                            }
                            
                        }
                    })
                    .padding()
                    Text(": \( manager.account.organizationName)")
                }
                .padding()
                    
                Spacer()
                Button {
                    manager.db.signUpUser(user: manager.account)
                    //nav to next View
                    navigate.toggle()
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
                .disabled(manager.account.organizationName.isEmpty)
                .padding(.vertical)
            }
            .task {
                do{
                    try await loadOrganizations()
                }
                catch{
                    print("There was an Error in JoinOrganization page line 65 Here it is: \(error.localizedDescription)")
                }
            }
        }
    }
    func loadOrganizations() async throws{
        let orgs = try await manager.db.loadOrganizations()
        for org in orgs{
            if org != nil{
                organizations.append(org!)
            } else{
                print(" Errror in Join Organization Page linne 62 the Organization was nil")
            }
        }
    }
    
}

struct JoinOrganizationPage_Previews: PreviewProvider {
    static var previews: some View {
        JoinOrganizationPage()
    }
}
