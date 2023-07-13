//
//  BaseStructs.swift
//  Hour.ly
//
//  Created by Eeshwar Parasuramuni on 7/6/23.
//

import Foundation

struct Organization : Codable, Identifiable{
    let id = UUID()
    let name : String
    let description : String
    var owner : User
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case owner

    }
    static let empty = Organization(name: "", description: "", owner: User.empty)
   
}

struct User : Codable, Identifiable{
    let id = UUID()
    var name : String
    var email : String
    var password : String
    var grade : Int
    var organizationName : String
    var isOwner : Bool
    var isAdmin : Bool
    var totalHours : Int
    var approvedHours : Int
    var deniedHours : Int
    var submissions : [Submission]
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case grade
        case organizationName
        case isOwner
        case isAdmin
        case totalHours
        case approvedHours
        case deniedHours
        case submissions
    }
    static let empty = User(name: "", email: "", password: "", grade: 0, organizationName: "", isOwner: false, isAdmin: false, totalHours: 0, approvedHours: 0, deniedHours: 0, submissions: [])
    
}

struct Submission : Codable, Identifiable{
    let id = UUID()
    let title : String
    let hours : Int
    let description : String
    let supervisor : String
    let name : String
    let email : String
    let supervisorEmail : String
    var photoFileURL : URL

    private enum CodingKeys: String, CodingKey {
        case title
        case hours
        case description
        case supervisor
        case name
        case email
        case supervisorEmail
        case photoFileURL
    }
    static let empty = Submission(title: "", hours: 0, description: "", supervisor: "", name: "", email: "", supervisorEmail: "", photoFileURL: URL(string: "")!)
}
