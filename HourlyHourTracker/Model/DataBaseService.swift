//
//  DatabaseService.swift
//  Hour.ly
//
//  Created by Eeshwar Parasuramuni on 7/6/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
struct DatabaseService {
    // this function will encode any object we pass to it and return a JSON String
    let db = Firestore.firestore()
    func encode<T: Encodable>(_ object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Encoding failed for object:", error)
        }
        
        return nil
    }
    //decodes a user from a dictionary
    func decodeUser(fromDictionary dictionary: [String: Any]) -> User? {
        guard let jsonString = dictionary[FirebaseStrings.user.rawValue] else {
            print("JSON string not found for key 'User'")
            return nil
        }
        
        guard let jsonData = (jsonString as! String).data(using: .utf8) else {
            print("Failed to convert JSON string to data")
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: jsonData)
            return user
        } catch {
            print("Failed to decode user: \(error)")
            return nil
        }
    }
    // decodes an organization from dictionary
    func decodeOrganization(fromDictionary dictionary: [String: Any]) -> Organization? {
        guard let jsonString = dictionary[FirebaseStrings.org.rawValue] else {
            print("JSON string not found for key 'Organization'")
            return nil
        }
        
        guard let jsonData = (jsonString as! String).data(using: .utf8) else {
            print("Failed to convert JSON string to data")
            return nil
        }
        
        do {
            let organization = try JSONDecoder().decode(Organization.self, from: jsonData)
            return organization
        } catch {
            print("Failed to decode organization: \(error)")
            return nil
        }
    }
    //instantiates new user object and then saves to whatever organization
    func signUpUser(user : User){
        
        // adding user to authentication
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            // if it works we are adding the user to the origanization in the firestore database
            if error == nil{
                let jsonString = encode(user)
                // going to orginzations collection then going to the document that is at the originizationName then going to that originzations sub-collection of users and adding the user as a dictionary of String String but really its String Json
                db.collection(FirebaseStrings.orgs.rawValue).document(user.organizationName).collection(FirebaseStrings.users.rawValue).document(user.email).setData([FirebaseStrings.user.rawValue: jsonString ?? ""])
                print("Just saved \(user.name) to \(user.organizationName)")
            }
            else{
                print("There was an error creating the account: \(error!.localizedDescription)")
            }
        }
    }
    func signUpUserGoogle(user : User){
        
    
                            let jsonString = encode(user)
                // going to orginzations collection then going to the document that is at the originizationName then going to that originzations sub-collection of users and adding the user as a dictionary of String String but really its String Json
                db.collection(FirebaseStrings.orgs.rawValue).document(user.organizationName).collection(FirebaseStrings.users.rawValue).document(user.email).setData([FirebaseStrings.user.rawValue: jsonString ?? ""])
                print("Just saved \(user.name) to \(user.organizationName)")
            
        
    }

    
    
        func signIn(email: String, password: String) async throws -> Bool {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                return true // Sign-in successful, return true
            } catch {
                // Handle any errors that occurred during sign-in
                print("Sign-in error: \(error.localizedDescription)")
                return false // Sign-in failed, return false
            }
        }
    
    
    
    //creates an originazation under the orginzation collection in cloud Firestore
    func createOrganization(org : Organization){
        // turning the org into a Json String
        let jsonString = encode(org)
        // Adding it to the collection organizations in a dict of "Orginzation" : String of JSON
        db.collection(FirebaseStrings.orgs.rawValue).document(org.name).setData([FirebaseStrings.org.rawValue : jsonString ?? ""])
    }
    
    // function to update a user in the database
    func updateUser(user : User){
        let jsonString = encode(user)
        // sets the document at location user.email in subcollection user in a certain org to current user data
        db.collection(FirebaseStrings.orgs.rawValue).document(user.organizationName).collection(FirebaseStrings.users.rawValue).document(user.email).setData([FirebaseStrings.user.rawValue: jsonString ?? ""])
    }
    // gets a user from database from their email
    func loadUser(email : String, orgName : String)async throws -> User?{
        do{
            // async expression waiting to get the documents data from the email
            let userData = try await db.collection(FirebaseStrings.orgs.rawValue).document(orgName).collection(FirebaseStrings.users.rawValue).document(email).getDocument().data()
            if userData != nil{
                return decodeUser(fromDictionary: userData!)
            }
            else{
                print("Ther Users data is nil")
            }
        }
        catch{
            print("There was a problem getting the user \(error.localizedDescription)")
        }
        return nil
    }
    // gets an organization from database from its name
    func loadOrganization(orgName : String) async throws -> Organization?{
        do{
            // async expression waiting to get the documents data based off the org name
            let orgData = try await db.collection(FirebaseStrings.orgs.rawValue).document(orgName).getDocument().data()
            if orgData != nil{
                return decodeOrganization(fromDictionary: orgData!)
            }
            else{
                print("Ther organizations data is nil")
            }
        }
        catch{
            print("There was a problem getting the organization \(error.localizedDescription)")
        }
        return nil
    }
    // gets all the organizations from the database
    func loadOrganizations() async throws -> [Organization?] {
        var orgArray = [Organization?]()
        // empty org array
        do {
            // gets the orgs
            let querySnapshot = try await db.collection(FirebaseStrings.orgs.rawValue).getDocuments()
            //loops through em each
            for document in querySnapshot.documents {
                // gets the data from each org and decodes it then appends to org array if it works
                let orgData = document.data()
                if let organization = decodeOrganization(fromDictionary: orgData) {
                    orgArray.append(organization)
                } else {
                    print("The organization data is nil")
                }
            }
        } catch {
            print("There was a problem getting the organizations: \(error.localizedDescription)")
        }
        
        return orgArray
    }
    
    
    // Load all the users from an organization
    func loadUsers(organizationName : String) async throws -> [User?]{
        var userArray = [User?]()
        // empty user array
        do{
            if !organizationName.isEmpty{
                let querySnapshot = try await db.collection(FirebaseStrings.orgs.rawValue).document(organizationName).collection(FirebaseStrings.users.rawValue).getDocuments()
                for document in querySnapshot.documents{
                    let userData = document.data()
                    if let user = decodeUser(fromDictionary: userData){
                        userArray.append(user)
                    } else{
                        print("The user data is nil")
                    }
                }
            }
        } catch{
            print("There was a problem getting the Users : \(error.localizedDescription)")
            
        }
        return userArray
    }
    
    //Find Organization returns the organization a user is in
 

 
    func LoadUserFromEmail(email: String) async throws -> User?{
      
        let orgs = try await db.collection(FirebaseStrings.orgs.rawValue).getDocuments()
        for orgDoc in orgs.documents{
           let org = decodeOrganization(fromDictionary: orgDoc.data())
            if let org = org{
                let userDocs = try await db.collection(FirebaseStrings.orgs.rawValue).document(org.name).collection(FirebaseStrings.users.rawValue).getDocuments()
                for userDoc in userDocs.documents{
                    let user = decodeUser(fromDictionary: userDoc.data())
                    if let user = user{
                        if user.email == email{
                            print(user)
                            return user
                        }
                    }
                }
                
            }
        }
        return nil
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Stores an image to a designated filepath
    func uploadImageToFirebaseStorage(image: UIImage, user: User, submission: Submission, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let storageRef = Storage.storage().reference()
        let userFolderRef = storageRef.child(user.name)
        let fileName = "\(submission.name).jpg"
        let fileRef = userFolderRef.child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = fileRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            fileRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                    
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                completion(.failure(error))
            }
        }
    }
    // downloads the image through the image download url
    func fetchImage(from imageURL: URL?) async throws -> UIImage {
        guard let url = imageURL else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid download URL"])
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        if let fetchedImage = UIImage(data: data) {
            return fetchedImage
        } else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image data"])
        }
    }
}
    
    enum FirebaseStrings : String {
        case user = "User"
        case org = "Organization"
        case orgs = "Organizations"
        case users = "Users"
    }

