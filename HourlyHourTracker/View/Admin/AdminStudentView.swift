//
//  AdminStudentView.swift
//  HourlyHourTracker
//
//  Created by Rohan Doshi on 7/22/23.
//

import SwiftUI

struct AdminStudentView: View {
    @EnvironmentObject var manager : AppManager
    @Binding var user : User
    let options = ["Pending", "Approved", "Denied"]
    @State var selected = "Pending"
    var body: some View {
        NavigationStack
        {
            VStack
            {
                HStack
                {
                    Text(user.name)
                        .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                        .foregroundColor(Color.black)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding([.leading, .bottom, .trailing])
                HStack
                {
                    //approved hours view
                    VStack(alignment: .leading)
                    {
                        Text("\(user.approvedHours)"  )
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
                        Text("\(user.totalHours - user.approvedHours - user.deniedHours)"  )
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
                        Text("\(user.deniedHours)"  )
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
                        Text("\(user.totalHours)"  )
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
                        ForEach($user.submissions)
                        {
                            submission in pending(submission: submission)
                        }
                        //.padding(10)
                        
                    }
                    if (options[1] == selected)
                    {
                        ForEach($user.submissions)
                        {
                            sub in
                            approved(submission: sub)
                        }
                        //.padding(10)
                    }
                    if (options[2] == selected)
                    {
                        ForEach($user.submissions)
                        {
                            sub in
                            denied(submission: sub)
                        }
                        //.padding(10)
                    }
                }
            }
            Spacer()
        }
        .padding()
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

struct AdminStudentView_Previews: PreviewProvider {
    static var previews: some View {
        AdminStudentView( user: Binding.constant(User.empty))
            .environmentObject(AppManager.example)
    }
}
