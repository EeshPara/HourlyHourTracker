//
//  ContentView.swift
//  Hour.ly
//
//  Created by Eeshwar Parasuramuni on 7/6/23.
//

import SwiftUI

struct WelcomePage: View {
    @EnvironmentObject var manager : AppManager
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
                NavigationLink {
                    SignUpPage()
                        .environmentObject(manager)
                } label: {
                    ZStack{
                        Text("Sign Up  👋")
                            .foregroundColor(Color("darkgrey"))
                            .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                            RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color("lightgrey2"), lineWidth: 1)
                                        .frame(width: 281, height: 65)
                    }
                }
                //signin link
                NavigationLink{
                    SignInPage()
                } label: {
                    Text("Already have an account? Sign In.")
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(40)
        }
    }
}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
            .environmentObject(AppManager())
    }
}
