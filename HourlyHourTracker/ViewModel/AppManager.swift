//
//  AppManager.swift
//  Hour.ly
//
//  Created by Eeshwar Parasuramuni on 7/6/23.
//

import Foundation

class AppManager: ObservableObject {
    @Published var account: User
    @Published var organization: Organization
    @Published var db : DatabaseService
    init(email: String, orgName: String) {
        account = User.empty
        organization = Organization.empty
        db = DatabaseService()
        
        Task.detached {
            await self.loadInfo(email: email, orgName: orgName)
        }
    }
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
    
    private func loadInfo(email: String, orgName: String)async{
        do {
            self.account = try await DatabaseService().loadUser(email: email, orgName: orgName) ?? User.empty
            self.organization = try await DatabaseService().loadOrganization(orgName: orgName) ?? Organization.empty
        } catch {
            print("Error loading user or organization: \(error)")
        }
    }
    static let example = AppManager()
    static var testManager = AppManager(account: User.testUser, organization: Organization.testOrg)

}

