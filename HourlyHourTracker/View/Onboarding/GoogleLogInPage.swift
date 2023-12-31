import SwiftUI

struct GoogleLoginPage: View {

  // 1

    @EnvironmentObject var manager : AppManager
    @State private var navigateToOrgs = false
    @State private var navigateToMain = false
  var body: some View {
    VStack {
      Spacer()
        NavigationLink("", isActive: $navigateToOrgs) {
            OrganizationPage()
                .environmentObject(manager)
        }
        NavigationLink("", isActive: $navigateToMain) {
            if manager.account.isOwner{
               OrgOwnerTabView()
                    .environmentObject(manager)
            } else if manager.account.isAdmin{
                AdminPage()
                    .environmentObject(manager)
            }else{
                StudentPage()
                    .environmentObject(manager)
            }
        }
        
      // 2
      
      Text("Welcome to Hour.ly!")
        .fontWeight(.black)
        .foregroundColor(Color(.systemIndigo))
        .font(.largeTitle)
        .multilineTextAlignment(.center)

      Text("Sign in with your school google account below!")
        .fontWeight(.light)
        .multilineTextAlignment(.center)
        .padding()

      Spacer()

      // 3
      GoogleSignInButton()
        .padding()
        .onTapGesture {
            Task{
                 await manager.authViewModel.signIn()
                try await loadUser()
               
            }
        }
    }
    .task{
//     
//            manager.authViewModel.signIn()
//            if(manager.authViewModel.state == .restoredSignIn){
//                toggle.toggle()
//            }
        
    }
 
  }
    func saveInfo(){
        if let email = manager.authViewModel.googleAccount?.profile?.email {
            manager.account.email = email
        }
        if let name = manager.authViewModel.googleAccount?.profile?.name{
            manager.account.name = name
        }
        print("User's name is \(manager.account.name)")
     
    }
    
    func loadUser() async throws{
        print("Loading user")
        saveInfo()
        let currentUser = manager.account
        manager.account = try await manager.db.LoadUserFromEmail(email: manager.account.email) ?? currentUser
        print("Account is \(manager.account)")
        if manager.account != currentUser{
            navigateToMain.toggle()
        }
        else if manager.account == User.empty{
           print("User canceled log in flow")
        }
        else{
            navigateToOrgs.toggle()
        }
     
    }
    
    
    
    
}
