//
//  AdminPage.swift
//  HourlyHourTracker
//
//  Created by Rohan Doshi on 7/22/23.
//

import SwiftUI

struct AdminPage: View {
    @State var users : [User] = [User.testUser, User.testAdmin, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser, User.testUser]
    @State var selected = "All"
    let options = ["All", "Admin", "Student"]
    @EnvironmentObject var manager : AppManager
    
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading) {
                Text("Welcome,\n" + firstName(name: manager.account.name))
                    .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Text("Manage your team.")
                    .padding()
                    .font(.system(size: 25))
                Picker("View", selection: $selected){
                    ForEach(options, id: \.self)
                    {
                        Text($0)
                    }
                }
                .padding()
                .pickerStyle(.segmented)
                ScrollView{
                    if (options[0] == selected)
                    {
                        ForEach($users) { user in
                            all(user: user)
                            .padding(10)}
                        
                    }
                    if (options[1] == selected)
                    {
                        ForEach($users) { user in
                            admin(user: user)
                            .padding(10)}
                    }
                    if (options[2] == selected)
                    {
                        ForEach($users) { user in
                            student(user: user)
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
    }
    
    
    struct AdminPage_Previews: PreviewProvider {
        static var previews: some View {
            AdminPage()
                .environmentObject(AppManager.testManager)
        }
    }
    
    
    
    struct all : View{
        @Binding var user : User
        var body: some View{
            
            ZStack{
                HStack{
                    Text(user.name)
                        .foregroundColor(Color("darkgrey"))
                        .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                    Spacer()
                    NavigationLink{
                        AdminStudentView()
                    }
                    label:{
                        Image(systemName: "arrowtriangle.forward.fill")
                    }
                    .foregroundColor(Color("burntsienna"))
                }
                .frame(maxWidth: 250, maxHeight: 50)
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color("lightgrey2"), lineWidth: 1)
                    .frame(width: 350, height: 65)
            }
            
        }
    }
    
    struct admin : View{
        @Binding var user : User
        var body: some View{
            if (user.isAdmin){
                ZStack{
                    HStack{
                        Text(user.name)
                            .foregroundColor(Color("darkgrey"))
                            .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                        Spacer()
                        NavigationLink{
                            AdminStudentView()
                        }
                        label:{
                            Image(systemName: "arrowtriangle.forward.fill")
                        }
                        .foregroundColor(Color("burntsienna"))
                    }
                    .frame(maxWidth: 250, maxHeight: 50)
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color("lightgrey2"), lineWidth: 1)
                        .frame(width: 350, height: 65)
                }
            }
        }
    }
    
    struct student : View{
        @Binding var user : User
        var body: some View{
            if (!user.isAdmin){
                ZStack{
                    HStack{
                        Text(user.name)
                            .foregroundColor(Color("darkgrey"))
                            .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                        Spacer()
                        NavigationLink{
                            AdminStudentView()
                        }
                        label:{
                            Image(systemName: "arrowtriangle.forward.fill")
                        }
                        .foregroundColor(Color("burntsienna"))
                    }
                    .frame(maxWidth: 250, maxHeight: 50)
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color("lightgrey2"), lineWidth: 1)
                        .frame(width: 350, height: 65)
                }
            }
        }
    }
    
    private func firstName(name: String) -> String
    {
        if let space = name.firstIndex(of: " ")
        {
            return name.substring(to: space)
        }
        return name
    }
}
