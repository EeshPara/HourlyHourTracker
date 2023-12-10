//
//  SubmissionViews.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 9/12/23.
//

import SwiftUI

struct pending : View
{
    @Binding var submission : Submission
    var body : some View
    {
        if (submission.approved == false && submission.denied == false)
        {
            NavigationLink
            {
                ReviewHoursPage(submission: submission, student: User.testUser)
            }
        label:
            {
                Text("\(submission.title) \(submission.submissionDate.formatted())").font(Font.custom("SF-Pro-Display-Bold", size: 17))
                    .foregroundColor(Color.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30.0)
                            .foregroundColor(Color("lightgrey1"))
                        //.padding()
                    )
            }
        }
    }
}
    
struct approved : View
{
    @Binding var submission : Submission
    var body : some View
    {
        if (submission.approved == true)
        {
            NavigationLink
            {
                ReviewHoursPage(submission: submission, student: User.testUser)
            }
        label:
            {
                Text("\(submission.title)\(submission.submissionDate.formatted())").font(Font.custom("SF-Pro-Display-Bold", size: 17))
                    .foregroundColor(Color.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30.0)
                            .foregroundColor(Color("lightgrey1"))
                        //.padding()
                    )
            }
        }
    }
}

struct denied : View
{
    @Binding var submission : Submission
    var body : some View
    {
        if (submission.denied == true)
        {
            NavigationLink
            {
                ReviewHoursPage(submission: submission, student: User.testUser)
            }
        label:
            {
                Text("\(submission.title) \(submission.submissionDate.formatted())").font(Font.custom("SF-Pro-Display-Bold", size: 17))
                    .foregroundColor(Color.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30.0)
                            .foregroundColor(Color("lightgrey1"))
                        //.padding()
                    )
            }
        }
    }
}
