//
//  HourSubmissionPage.swift
//  HourlyHourTracker
//
//  Created by Laksh Gulati on 7/20/23.
//

import SwiftUI

struct HourSubmissionPage: View {
    @EnvironmentObject var manager : AppManager
    
    @State private var reasons: [String] = []
    @State private var reasonString = ""
    @State private var navigate = false
    
    @State var activityName : String = ""
    @State var supervisorName : String = ""
    @State var supervisorEmail : String = ""
    @State var hours : String = ""
    @State var description : String = ""
    var body: some View {
        NavigationStack
        {
            VStack
            {
                TextField("Activity Name", text: $activityName)
                        .padding()
                        .autocapitalization(.none)
                        .font(
                            .custom("SF-Pro-Display-Bold", size: 24))
                        .foregroundColor(Color(.black))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            )
                        .frame(width: 308, height: 75)
                TextField("Supervisor Name", text: $supervisorName)
                        .padding()
                        .autocapitalization(.none)
                        .font(
                            .custom("SF-Pro-Display-Bold", size: 24))
                        .foregroundColor(Color(.black))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            )
                        .frame(width: 308, height: 75)
                TextField("Supervisor Email", text: $supervisorEmail)
                        .padding()
                        .autocapitalization(.none)
                        .font(
                            .custom("SF-Pro-Display-Bold", size: 24))
                        .foregroundColor(Color(.black))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            )
                        .frame(width: 308, height: 75)
                TextField("Number of Hours", text: $hours)
                        .padding()
                        .autocapitalization(.none)
                        .font(
                            .custom("SF-Pro-Display-Bold", size: 24))
                        .foregroundColor(Color(.black))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            )
                        .frame(width: 308, height: 75)
                TextField("Description", text: $description, axis: .vertical)
                        .padding()
                        .autocapitalization(.none)
                        .font(
                            .custom("SF-Pro-Display-Bold", size: 24))
                        .foregroundColor(Color(.black))
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                                .frame(width: 308, height: 200)
                            )
                        .multilineTextAlignment(.leading)
                        .lineLimit(2...4)
                        .frame(width: 308, height: 200)
                
                        Spacer()
                Text(reasonString)
                    .font(Font.custom("SF-Pro-Display-Bold", size: 14))
                    .foregroundColor(Color("burntsienna"))
                
                Button{
                    if !readyToContinue(){
                        displayReasons()
                    }
                    else{
                        displayReasons()
                        // toggle navigation
                        navigate.toggle()
                        //add back end here
                     
                    }
                 } label: {
                     ZStack{
                         RoundedRectangle(cornerRadius: 30)
                             .fill(Color("darkgrey"))
                             .frame(width: 281, height: 65)
                         Text("Submit")
                             .foregroundColor(Color.white)
                             .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                     }
                 }
                
            }
        }
    }
    
    private func readyToContinue() -> Bool
    {
        displayReasons()
        var n = validName(name: activityName)
        var sn = validSupName(name: supervisorName)
        var h = validHours(hours: hours)
        var d = validDescritpion(description: description)
        let email = validEmail(email: supervisorEmail)
        
        return n && sn  && d && h && email
    }
    
    private func validName(name : String) -> Bool
    {
        if (name.count > 0)
        {
            removeReason(reason: "Please enter the activity name.")
            return true
        }
        else
        {
            addReason(reason: "Please enter the activity name.")
            return false
        }
    }
    
    private func validSupName(name : String) -> Bool
    {
        if (name.count > 0)
        {
            removeReason(reason: "Please enter the supervisor name.")
            return true
        }
        else
        {
            addReason(reason: "Please enter the supervisor name.")
            return false
        }
    }
    
    private func validDescritpion(description : String) -> Bool
    {
        if (description.count > 0)
        {
            removeReason(reason: "Please enter a valid description.")
            return true
        }
        else
        {
            addReason(reason: "Please enter a valid description.")
            return false
        }
        
    }

    private func validEmail(email : String) -> Bool
    {
        var prefix : String = ""
        var address : String = ""
        if let index = email.firstIndex(of: "@")
        {
            prefix = email.substring(to: index)
            address = email.substring(from: email.index(after: index))
        }
        else
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
        if (prefix.count < 1 || prefix.count > 64)
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
        if (address.count < 2)
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
        if let dot = address.firstIndex(of: ".")
        {
            if dot > address.startIndex && dot < address.index(before: address.endIndex)
            {
                removeReason(reason: "Please enter a valid email.")
                return true
            }
            addReason(reason: "Please enter a valid email.")
            return false
        }
        else
        {
            addReason(reason: "Please enter a valid email.")
            return false
        }
    }
    
    private func validHours(hours : String) -> Bool
    {
        var h : Int = Int(hours) ?? -1
        if (h == -1 || !(hours.count > 0))
        {
            addReason(reason: "Please enter a positive integer value for number of hours.")
            return false
        }
        removeReason(reason: "Please enter a positive integer value for number of hours.")
        return true
    }
    
    //adds reason while checking for duplicates
    private func addReason(reason : String)
    {
        if (!reasons.contains(reason))
        {
            reasons.append(reason)
        }
    }
    private func removeReason(reason : String)
    {
        if (reasons.contains(reason))
        {
            reasons.remove(at: reasons.firstIndex(of: reason)!)
        }
    }
    
    private func displayReasons()
    {
        reasonString = ""
        for reason in reasons {
            reasonString += reason + "\n"
        }
    }
}

struct HourSubmissionPage_Previews: PreviewProvider {
    static var previews: some View {
        HourSubmissionPage()
            .environmentObject(AppManager.testManager)
    }
}
