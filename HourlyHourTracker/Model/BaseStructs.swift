//
//  BaseStructs.swift
//  Hour.ly
//
//  Created by Eeshwar Parasuramuni on 7/6/23.
//

import Foundation

struct Organization : Codable, Identifiable, Hashable{
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(name)
       }
    
    static func == (lhs: Organization, rhs: Organization) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    let id = UUID()
    var name : String
    var description : String
    var owner : User
    var users : [User]
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case owner
        case users
    }
    static let empty = Organization(name: "", description: "", owner: User.empty, users: [User.empty])
    static let testOrg = Organization(name: "NHS", description: "this is a very interesting organization", owner: User.testUser, users: [User.empty])
   
}

struct User : Codable, Identifiable, Hashable {
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(name)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
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
    static let testUser = User(name: "Laksh Gulati", email: "lakshgulati5@gmail.com", password: "password", grade: 12, organizationName: "", isOwner: false, isAdmin: false, totalHours: 21, approvedHours: 15, deniedHours: 4, submissions: [])
    
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
