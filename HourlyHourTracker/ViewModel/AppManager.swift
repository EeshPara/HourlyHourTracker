//
//  AppManager.swift
//  Hour.ly
//
//  Created by Eeshwar Parasuramuni on 7/6/23.
//

import Foundation
//The most important object in the app it organizes the app
class AppManager: ObservableObject {
    // the current user loaded in
    @Published var account: User
    // the organization the user is apart of
    @Published var organization: Organization
    //Database service obejct that allows us to easily call functions that allow us to interact with the database
    @Published var db : DatabaseService
    //Authentication view
    @Published var authViewModel = AuthenticationViewModel()
 // empty 
    init(){
        account = User.empty
        organization = Organization.empty
        db = DatabaseService()
    }
    init(account: User, organization: Organization)
    {
        self.account = account
        self.organization = organization
        db = DatabaseService()
    }
    static let example = AppManager()
    static var testManager = AppManager(account: User.testUser, organization: Organization.testOrg)

}

