//
//  OrgOwnerPage.swift
//  HourlyHourTracker
//
//  Created by Rohan Doshi on 7/22/23.
//

import SwiftUI

struct OrgOwnerPage: View {
    @State var users : [User] = [User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser]
    @EnvironmentObject var manager : AppManager
    var body: some View {
        VStack (alignment: .leading){
            Text(Organization.testOrg.name)
                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                .foregroundColor(Color.black)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(25)
            
            ScrollView{
                
                ForEach(users) { user in
                    ZStack{
                        HStack{
                            Text(user.name)
                                .foregroundColor(Color("darkgrey"))
                                .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                            Spacer()
                            Menu("Manage")
                            {
                                if (user.isAdmin)
                                {
                                    Button("Remove Admin")
                                    {
//                                        user.isAdmin.toggle()
                                    }
                                }
                                else
                                {
                                    Button("Make Admin")
                                    {
//                                        user.isAdmin.toggle()
                                    }
                                }
                            }
                            .foregroundColor(Color("burntsienna"))
                        }
                        .frame(maxWidth: 250, maxHeight: 50)
                        RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color("lightgrey2"), lineWidth: 1)
                                    .frame(width: 350, height: 65)
                    }
                    .padding(10)
                    
                }
            }
           
        }
        .task {
            do{
                let optionalusers = try await manager.db.loadUsers(organizationName: Organization.testOrg.name)
                for user in optionalusers{
                    if let userThatIsntNil = user{
                        users.append(userThatIsntNil)
                    }
                }

            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
}

struct OrgOwnerPage_Previews: PreviewProvider {
    static var previews: some View {
        OrgOwnerPage()
            .environmentObject(AppManager.example)
    }
}