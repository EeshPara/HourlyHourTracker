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
      Image("header_image")
        .resizable()
        .aspectRatio(contentMode: .fit)

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
                manager.authViewModel.signIn()
                if manager.authViewModel.state == .signedIn{
                    await saveInfo()
                    navigateToOrgs.toggle()
                }
                else if manager.authViewModel.state == .restoredSignIn{
                   
                    saveInfo()
                    manager.account = try await manager.db.LoadUserFromEmail(email: manager.account.email) ?? User.empty
                    manager.account.isAdmin = false
                    navigateToMain.toggle()
                }
            }
        }
    }
  }
    func saveInfo(){
        if let email = manager.authViewModel.googleAccount?.profile?.email {
            manager.account.email = email
        }
        if let name = manager.authViewModel.googleAccount?.profile?.name{
            manager.account.name = name
        }
        
     
       
        
    }
    
    
    
    
}
