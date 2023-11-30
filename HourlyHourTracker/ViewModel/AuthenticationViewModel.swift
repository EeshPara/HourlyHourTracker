//
//  AuthenticationViewModel.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 9/10/23.
//

import Firebase
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {

  // 1
  enum SignInState {
    case signedIn
    case signedOut
    case restoredSignIn
  }

  // 2
  @Published var state: SignInState = .signedOut
    @Published var googleAccount : GIDGoogleUser? = nil
    
    func signIn() {
      // 1
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error, restoring: true)
        }
      } else {
        // 2
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // 3
          let configuration = GIDConfiguration(clientID: clientID)
        
        // 4
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        // 5
          GIDSignIn.sharedInstance.configuration = configuration
          GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) {user, error in
              self.authenticateUser(for: user?.user, with: error, restoring: false)
          }
      }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?, restoring: Bool) {
        if let user{
            // 1
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // 2
            guard let idToken = user.idToken else { return }
            
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            
            // 3
            Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if restoring{
                        self.state = .restoredSignIn
                    }
                    else{
                        self.state = .signedIn
                    }
                    googleAccount = user
                }
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
        
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }
    
}