//
//  GoogleSignIn.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 9/12/23.
//

import SwiftUI
import GoogleSignIn
import Firebase
class GoogleSignIn: ObservableObject {
    
    @Published var name: String = ""
    @Published var profilePicUrl: URL?
    @Published var email: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
    init(){
        //check()
    }
    
    func checkStatus(){
        print("got to check status")
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let name = user.profile?.name
            let email = user.profile?.email
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)
            self.name = name ?? ""
            self.profilePicUrl = profilePicUrl
            self.email = email ?? ""
            self.isLoggedIn = true
            print(isLoggedIn)
            print("is logged in is true")
        }else{
            self.isLoggedIn = false
            self.name = ""
            self.profilePicUrl = nil
            self.email = email
        }
    }
    
    func check(){
        print("called method")
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            print("restoring user")
            if let error = error {
                print("error dawg")
                self.errorMessage = "error: \(error.localizedDescription)"
            }else{
                self.checkStatus()
            }
            print("no error")
        }
    
    }
    
    func signIn(){
        if GIDSignIn.sharedInstance.hasPreviousSignIn(){
            check()
            return
        }
       guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: "142675998353-d5sqbdqq7kjtgfmrrbfocol99qn8nnus.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.configuration = signInConfig
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) {user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
