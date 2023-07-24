//
//  ReviewHoursPage.swift
//  HourlyHourTracker
//
//  Created by Laksh Gulati on 7/22/23.
//

import SwiftUI

struct ReviewHoursPage: View {
    let submission : Submission
    let student : User
    @EnvironmentObject var manager : AppManager
    var body: some View {
        NavigationStack
        {
            VStack
            {
                HStack
                {
                    Text("\(submission.title)")
                        .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                        .foregroundColor(Color.black)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                    VStack
                    {
                        if (submission.approved == false && submission.denied == false)
                        {
                            Text("\(submission.hours)")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(Color(red: 0.6352941176470588, green: 0.7647058823529411, blue: 0.6392156862745098))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                            Text("Pending Hours")
                        }
                        else if (submission.approved)
                        {
                            Text("\(submission.hours)")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(Color.green)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                            Text("Approved Hours")
                        }
                        else if (submission.denied)
                        {
                            Text("\(submission.hours)")
                                .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                                .foregroundColor(Color.red)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .multilineTextAlignment(.leading)
                            Text("Denied Hours")
                        }
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)
                Text("Student: \(student.name)")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 17))
                HStack
                {
                    Text("Supervisor:")
                        .font(Font.custom("SF-Pro-Display-Bold", size: 17))
                    Link ("\(submission.supervisor)", destination: URL(string: submission.supervisorEmail)!)
                
                }
                Text("\(submission.description)")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 17))
                    .padding(.all, 60.0)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .padding(.all, 30.0)
                            .foregroundColor(Color("lightgrey1")))
                Spacer()
            }
        }
    }
}

struct ReviewHoursPage_Previews: PreviewProvider {
    static var previews: some View {
        ReviewHoursPage(submission: Submission.example, student: User.testUser)
            .environmentObject(AppManager.example)
    }
}
