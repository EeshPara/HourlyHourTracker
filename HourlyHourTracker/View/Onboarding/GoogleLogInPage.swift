import SwiftUI

struct GoogleLoginPage: View {

  // 1

    @EnvironmentObject var manager : AppManager
    @State private var navigateToOrgs = false
    @State private var navigateToMain = false
  var body: some View {
      NavigationStack{
          VStack{
              //logo
              Text("hour.ly")
                  .font(Font.custom("SF-Pro-Display-Bold", size: 75))
                  .foregroundColor(Color("darkgrey"))
                  .font(.largeTitle)
                  .fontWeight(.semibold)
                  .multilineTextAlignment(.center)
                  .padding(.top, 235.0)
              //subheading
              Text("Volunteer Tracker")
                  .font(Font.custom("Scada-Regular", size: 25))
                  .foregroundColor(Color("burntsienna"))
              Spacer()
              //signup button
                  ZStack{
                      Text("Sign Up  👋")
                          .foregroundColor(Color("darkgrey"))
                          .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                      RoundedRectangle(cornerRadius: 30)
                          .stroke(Color("lightgrey2"), lineWidth: 1)
                          .frame(width: 281, height: 65)
                  }
                  .padding()
                  .onTapGesture {
                      Task{
                           await manager.authViewModel.signIn()
                          try await loadUser()
                         
                      }
                  }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .padding(40)
      }
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

      // 3
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
        else{
            navigateToOrgs.toggle()
        }
     
    }
    
    
    
    
}
