import SwiftUI

struct GoogleLoginView: View {

  // 1

    @EnvironmentObject var manager : AppManager
    @State private var navigateToOrgs = false
    @State private var navigateToMain = false
    @State private var toggle = false
    @StateObject var googleSignIn = GoogleSignIn()
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
     
    }
    .task{
        
        googleSignIn.check()
     
       
    }
    .onChange(of: googleSignIn.isLoggedIn){ newVal in
        print("is logged in changed")
        if newVal{
            Task {
                do {
                   try await loaduser()
                    
                } catch {
                   
                }
            }
        }
        
    }
    
  }

    func loaduser() async throws{
   
        manager.account = try await manager.db.LoadUserFromEmail(email: googleSignIn.email) ?? User.empty
        manager.account.isAdmin = false
        navigateToMain.toggle()
    }

    
    
    
    
}
