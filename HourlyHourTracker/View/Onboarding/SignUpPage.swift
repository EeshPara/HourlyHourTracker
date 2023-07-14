//
//  SignUpPage.swift
//  Hour.ly
//
//  Created by Rohan Doshi on 7/7/23.
//

import SwiftUI

struct SignUpPage: View {
    @EnvironmentObject var manager : AppManager
    @State private var reasons: [String] = []
    @State private var reasonString = ""
    @State private var navigate = false
    var body: some View {
        NavigationStack{
            VStack{
                
                NavigationLink(destination: OrganizationPage().environmentObject(manager), isActive: $navigate) {
                    EmptyView()
                }
                
                //logo
                Text("Sign Up")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 20)
                Spacer()
                TextField("Name", text: $manager.account.name)
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
                TextField("Email", text: $manager.account.email)
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
                SecureField("Password", text: $manager.account.password)
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
                Text("Used to register account")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 14))
                    .foregroundColor(Color("lightgrey1"))
                
                Text(reasonString)
                    .font(Font.custom("SF-Pro-Display-Bold", size: 14))
                    .foregroundColor(Color("burntsienna"))

                //subheading
                Spacer()

                //signup button
                
                   Button{
                       if !readyToContinue(){
                           displayReasons()
                       }
                       else{
                           displayReasons()
                           // toggle navigation
                           navigate.toggle()
                        
                       }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("darkgrey"))
                                .frame(width: 281, height: 65)
                            Text("Sign Up")
                                .foregroundColor(Color.white)
                                .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                        }
                    }
                   
                
               
         
//                Text("By continuing you agree to our Terms of Service")
//                    .foregroundColor(.black)
//                    .font(Font.custom("SF-Pro-Display-Bold", size: 14))
//                    .padding(.top)
                   
                    
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(0.0)
        }
        .padding()
    }
   
    private func readyToContinue() -> Bool
    {
        displayReasons()
        let n = validName(name: manager.account.name)
        let email = validEmail(email: manager.account.email)
        let pass = validPassword(password: manager.account.password)
        return n && email && pass
    }
    
    private func validName(name : String) -> Bool
    {
        if (name.count > 0)
        {
            removeReason(reason: "Please enter your name.")
            return true
        }
        else
        {
            addReason(reason: "Please enter your name.")
            return false
        }
        
    }

    private func validEmail(email : String) -> Bool
    {
        var prefix : String = ""
        var address : String = ""
        if let index = email.firstIndex(of: "@")
        {
            prefix = email.substring(to: index)
            address = email.substring(from: email.index(after: index))
        }
        else
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
        if (prefix.count < 1 || prefix.count > 64)
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
        if (address.count < 2)
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
        if let dot = address.firstIndex(of: ".")
        {
            if dot > address.startIndex && dot < address.index(before: address.endIndex)
            {
                removeReason(reason: "Please enter a valid email.")
                return true
            }
            addReason(reason: "Please enter a valid email.")
            return false
        }
        else
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
    }

    private func validPassword(password : String) -> Bool
    {
        let specialCharacters = "!@#$%^&*();:'[]{}`~-=+,./?|<>"
        if (password.count < 8)
        {
            addReason(reason: "Please enter a password of 8 characters or longer.")
            return false
        }
        else
        {
            removeReason(reason: "Please enter a password of 8 characters or longer.")
            return true
        }
    }
    
    //adds reason while checking for duplicates
    private func addReason(reason : String)
    {
        if (!reasons.contains(reason))
        {
            reasons.append(reason)
        }
    }
    private func removeReason(reason : String)
    {
        if (reasons.contains(reason))
        {
            reasons.remove(at: reasons.firstIndex(of: reason)!)
        }
    }
    
    private func displayReasons()
    {
        reasonString = ""
        for reason in reasons {
            reasonString += reason + "\n"
        }
    }
}


struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
