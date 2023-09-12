//
//  SignInPage.swift
//  Hour.ly
//
//  Created by Rohan Doshi on 7/7/23.
//

import SwiftUI

struct SignInPage: View {
    @EnvironmentObject var manager : AppManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var orgName : String = ""
    @State private var organizations = [Organization]()
    @State private var navigate = false
    var body: some View {
        NavigationStack{
            VStack{
                //logo
                Text("Sign In")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 0)
                Spacer()
                TextField("Email", text: $email)
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
                SecureField("Password", text: $password)
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
                
                HStack{
                    Menu("Organizations", content: {
                        ForEach(organizations){ organization in
                            Button(organization.name){
                                orgName = organization.name
                            }
                            
                        }
                    })
                    .padding()
                    Text(": \( orgName)")
                }
                .padding()
                    
                
                //subheading
                Spacer()

                //signup button
                Button {
                    Task{
                        try await signIn()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("darkgrey"))
                                    .frame(width: 281, height: 65)
                        Text("Continue")
                            .foregroundColor(Color.white)
                            .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                                                }
                }
                .disabled(email.isEmpty || password.isEmpty || orgName.isEmpty)
                //signin link
                
//                NavigationLink(destination: {
//                    if manager.account.isOwner {
//                        OrgOwnerTabView()
//                            .environmentObject(manager)
//                    } else if manager.account.isAdmin {
//                        AdminPage()
//                            .environmentObject(manager)
//                    } else {
//                        StudentPage()
//                            .environmentObject(manager)
//                    }
//                }, isActive: $navigate){
//                    EmptyView()
//                }
              
//                NavigationLink{
//
//                    if manager.account.isOwner{
//                        OrgOwnerTabView()
//                    }
//                    else if manager.account.isAdmin{
//                        AdminPage()
//                    }
//                    else{
//                        StudentPage()
//                    }
//
//                } label: {
//                    Text("By continuing you agree to our Terms of Service")
//                        .foregroundColor(.black)
//                        .font(Font.custom("SF-Pro-Display-Bold", size: 14))
//                        .padding(.top)
//
//                }
            }
           
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(0.0)
        }
        .task {
            do{
                try await loadOrganizations()
            }
            catch{
                print("There was an Error in JoinOrganization page line 65 Here it is: \(error.localizedDescription)")
            }
        }

        .padding()
    }
    
    func signIn() async throws{
        var authenticated = try await manager.db.signIn(email: email, password: password)
        if authenticated{
            var account = try await manager.db.loadUser(email: email, orgName: orgName)
            if account != nil{
                manager.account = account!
                print(account)
            }
            else{
                print("There was an error in the Sign in page and the account that was loaded was nil")
            }
            var org = try await manager.db.loadOrganization(orgName: orgName)
            if org != nil{
                manager.organization = org!
                print(org)
                navigate.toggle()
            }
            else{
                print("There was an error in the Sign in Page and the org that was loaded was nil")
            }
           print(manager)
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

struct SignInPage_Previews: PreviewProvider {
    static var previews: some View {
        SignInPage()
            .environmentObject(AppManager())
    }
}
