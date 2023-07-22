//
//  OrgOwnerPage.swift
//  HourlyHourTracker
//
//  Created by Rohan Doshi on 7/22/23.
//

import SwiftUI

struct OrgOwnerPage: View {
    @State var users : [User] = [User]()
    @EnvironmentObject var manager : AppManager
    var body: some View {
        VStack{
            ForEach(users){ user in
                
            }
         
        }
        .task {
            do{
                let optionalusers = try await manager.db.loadUsers(organizationName: manager.account.organizationName)
                for user in optionalusers{
                    if let userThatIsntNil = user{
                        users.append(userThatIsntNil)
                    }
                }
                
            }
            catch{
                
            }
        }
    }
}

struct OrgOwnerPage_Previews: PreviewProvider {
    static var previews: some View {
        OrgOwnerPage()
    }
}
