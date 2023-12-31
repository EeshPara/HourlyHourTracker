//
//  StudentPage.swift
//  HourlyHourTracker
//
//  Created by Laksh Gulati on 7/20/23.
//

import SwiftUI

struct StudentPage: View {
    @EnvironmentObject var manager : AppManager
    
    let options = ["Pending", "Approved", "Denied"]
    @State var selected = "Pending"
    @State var submissions : [Submission] = [Submission.pending, Submission.pending, Submission.approved, Submission.denied]
    @State var signedOut = false
    
    var body: some View {
        NavigationStack
        {
            NavigationLink(isActive: $signedOut) {
                ContentView()
            } label: {
                EmptyView()
            }

            ScrollView{
                VStack
                {
                    Button("SignOut"){
                        manager.authViewModel.signOut()
                        signedOut = true
                    }
                    
                    HStack
                    {
                        Text("Welcome,\n" + firstName(name: manager.account.name))
                            .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                            .foregroundColor(Color.black)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        NavigationLink()
                        {
                            HourSubmissionPage()
                        }
                    label:
                        {
                            Text("+")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(Color.white)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                                .background(
                                    Circle()
                                        .frame(width: 50.0, height: 50.0)
                                        .foregroundColor(Color("burntsienna"))
                                )
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                    HStack
                    {
                        //approved hours view
                        VStack(alignment: .leading)
                        {
                            Text("\(manager.account.approvedHours)"  )
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(.green)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 40.0)
                            Text("Approved Hours")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 15))
                        }
                        .padding(.leading, 40.0)
                        Spacer()
                        //pending hours view
                        VStack(alignment: .trailing)
                        {
                            Text("\(manager.account.totalHours - manager.account.approvedHours - manager.account.deniedHours)"  )
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(Color(red: 0.6352941176470588, green: 0.7647058823529411, blue: 0.6392156862745098))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                                .padding(.trailing, 40.0)
                            Text("Pending Hours")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 15))
                        }
                        .padding(.trailing, 40.0)
                    }
                    HStack
                    {
                        //denied hours view
                        VStack(alignment: .leading)
                        {
                            Text("\(manager.account.deniedHours)"  )
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(.red)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 40.0)
                            Text("Denied Hours")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 15))
                        }
                        .padding(.leading, 40.0)
                        Spacer()
                        //total hours view
                        VStack(alignment: .trailing)
                        {
                            Text("\(manager.account.totalHours)"  )
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                                .padding(.trailing, 40.0)
                            Text("Total Hours")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 15))
                                .padding(.trailing, 15.0)
                        }
                        .padding(.trailing, 40.0)
                    }
                    .padding(.vertical)
                    Picker("View", selection: $selected)
                    {
                        ForEach(options, id: \.self)
                        {
                            Text($0)
                        }
                    }
                    .padding()
                    .pickerStyle(.segmented)
                    ScrollView{
                        if (options[0] == selected)
                        {
                            ForEach($manager.account.submissions, id: \.self) {  sub in
                                pending(submission: sub)
                            }
                            //.padding(10)
                            
                        }
                        if (options[1] == selected)
                        {
                            ForEach($manager.account.submissions, id: \.self)
                            {
                                sub in
                                approved(submission: sub)
                            }
                            //.padding(10)
                        }
                        if (options[2] == selected)
                        {
                            ForEach($manager.account.submissions, id: \.self)
                            {
                                sub in
                                denied(submission: sub)
                            }
                            //.padding(10)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        }
    }

}

private func firstName(name: String) -> String
{
    if let space = name.firstIndex(of: " ")
    {
        return name.substring(to: space)
    }
    return name
}

struct StudentPage_Previews: PreviewProvider {
    static var previews: some View {
        StudentPage()
            .environmentObject(AppManager.testManager)
    }
}
