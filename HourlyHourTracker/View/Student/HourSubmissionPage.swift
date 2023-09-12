//
//  HourSubmissionPage.swift
//  HourlyHourTracker
//
//  Created by Laksh Gulati on 7/20/23.
//

import SwiftUI
import VisionKit

struct HourSubmissionPage: View {
    @EnvironmentObject var manager : AppManager
    
    @State private var reasons: [String] = []
    @State private var reasonString = ""
    @State private var navigate = false
    @State private var showScannerSheet = false
    @State private var submissionImage : UIImage = UIImage()
    @State var submission: Submission = Submission.empty
    var body: some View {
        NavigationStack
        {
            ScrollView{
                VStack
                {
                    
                    
                    TextField("Activity Name", text: $submission.title)
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
                    TextField("Supervisor Name", text: $submission.supervisor)
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
                    TextField("Supervisor Email", text: $submission.supervisorEmail)
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
                    TextField("Number of Hours", value: $submission.hours, formatter: NumberFormatter())
                        .foregroundColor(.gray)
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
                    TextField("Description", text: $submission.description, axis: .vertical)
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
                    
                    HStack{
                        Text("Upload a photo: ")
                            .foregroundColor(.gray)
                        Spacer()
                        Button{
                            showScannerSheet.toggle()
                        } label : {
                            Text("Add")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(30)
                    .frame(width: 308)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412))
                            .frame(width: 308, height: 50)
                    )
                    
                    
                    Spacer()
                    Text(reasonString)
                        .font(Font.custom("SF-Pro-Display-Bold", size: 14))
                        .foregroundColor(Color("burntsienna"))
                 
                    Image(uiImage: submissionImage)
                        .resizable()
                        .frame(maxWidth: 150, maxHeight: 150)
                        .cornerRadius(12.0)
                    
                    
                    Button{
                        if !readyToContinue(){
                            displayReasons()
                        }
                        else{
                            displayReasons()
                        
                            uploadSubmission()
                            // toggle navigation
                            navigate.toggle()
                            
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
        .popover(isPresented: $showScannerSheet){
            makeScannerView()
        }
        
    }
    private func makeScannerView()-> ScannerView {
        ScannerView { image in
            if let uiImage = image{
                submissionImage = uiImage
            }
            showScannerSheet.toggle()
        }
    }
    private func uploadSubmission(){
        // appending the info and hours
        Task{
            await saveImage()
            manager.account.submissions.append(submission)
            manager.account.totalHours += submission.hours
            //updating in database
            manager.db.updateUser(user: manager.account)
        }
    }
    private func saveImage() async{
       try await manager.db.uploadImageToFirebaseStorage(image: submissionImage, user: manager.account, submission: submission) { result in
            switch result {
              case .success(let value):
              
                    submission.photoFileURL = URL(string: value) ?? URL(string: "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg")!
                
              case .failure(let error):
                print("Error: \(error.localizedDescription)")
              }
            
        }
    }
    
    private func readyToContinue() -> Bool
    {
        displayReasons()
        var n = validName(name: submission.title)
        var sn = validSupName(name: submission.supervisor)
        var h = validHours(hours: "\(submission.hours)")
        var d = validDescritpion(description: submission.description)
        let email = validEmail(email: submission.supervisorEmail)
        
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
