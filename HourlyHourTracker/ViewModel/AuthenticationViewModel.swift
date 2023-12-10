//
//  AuthenticationViewModel.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 9/10/23.
//

import Firebase
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {



  // 2
    @Published var googleAccount : GIDGoogleUser? = nil
    
    func signIn() async {
      // 1
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
         print("has previous sign in")
          do{
              let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
              
              print("restored previous user")
              print("This is the user \(user)")
              await authenticateUser(for: user)
              return
          } catch{
              print("User could not be loaded from previous sign in")
          }
              
         
      } else {
        // 2
         let clientID = "653468434039-b05ut55b90ha6o89s1ej4uurctdmoj54.apps.googleusercontent.com" 
        
        // 3
          let configuration = GIDConfiguration(clientID: clientID)
        
        // 4
        
          guard let presentingViewController = await (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        // 5
          GIDSignIn.sharedInstance.configuration = configuration
          do{
             let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
              
               await self.authenticateUser(for: result.user)
          }
          catch{
              print("Couldn't authenticate the user")
          }
         
      }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?) async {
        if let user{
         
            
            // 2
            guard let idToken = user.idToken else { return }
            
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            
            // 3
            do{
                try await Auth.auth().signIn(with: credential)
                googleAccount = user
            } catch{
                print(error.localizedDescription)
            }
            
        }
        else{
            print("User is nil")
            return
        }
    }
        
    func signOut() {
      // 1
      GIDSignIn.sharedInstance.signOut()
      
      do {
        // 2
        try Auth.auth().signOut()
        
      } catch {
        print(error.localizedDescription)
      }
    }
    
}
