//
//  JoinOrganizationPage.swift
//  HourlyHourTracker
//
//  Created by Eeshwar Parasuramuni on 7/13/23.
//

import SwiftUI

struct JoinOrganizationPage: View {
    @EnvironmentObject var manager : AppManager
    @State private var organizations = [Organization]()
    @State private var navigate = false
    @State private var searchText = ""
    @State private var isExpanded = false
    @State private var selectedOrganization: Organization?
    private var filteredItems: [Organization] {
            searchText.isEmpty ? organizations : organizations.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    var body: some View {
        NavigationStack
        {
            VStack
            {
                Text("Join an Organization")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical)
                Text("Browse Organizations")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 30))
                    .padding(.top)
                DisclosureGroup(
                                isExpanded: $isExpanded,
                                content: {
                                    VStack {
                                        SearchBar(searchText: $searchText)
                                        
                                        ForEach(filteredItems, id: \.self) { item in
                                            Button(action: {
                                                selectedOrganization = item
                                                isExpanded.toggle()
                                                // Perform action when item is selected
                                            }) {
                                                Text(item.name)
                                                    .foregroundColor(.primary)
                                                    .padding(.vertical, 8)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                                },
                                label: {
                                    HStack {
                                        Text(" \(selectedOrganization?.name ?? "Select an option")")
                                            .foregroundColor(.primary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(Color.secondary.opacity(0.2))
                                    .cornerRadius(8)
                                }
                )
                .frame(width: 308.0)
                
//                Text("OR")
//                    .foregroundColor(Color("burntsienna"))
                Spacer()
                Button {
                    manager.db.signUpUser(user: manager.account)
                    //nav to next View
                    navigate.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("darkgrey"))
                            .frame(width: 281, height: 65)
                        Text("Join")
                            .foregroundColor(Color.white)
                            .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                    }
                }
                .disabled(manager.account.organizationName.isEmpty)
                .padding(.vertical)
            }
            .task {
                do{
                    try await loadOrganizations()
                }
                catch{
                    print("There was an Error in JoinOrganization page line 65 Here it is: \(error.localizedDescription)")
                }
            }
        }
    }
    func loadOrganizations() async throws{
        let orgs = try await manager.db.loadOrganizations()
        for org in orgs{
            if org != nil{
                organizations.append(org!)
            } else{
                print(" Errror in Join Organization Page linne 62 the Organization was nil")
            }
        }
    }
    
}
struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 10)
    }
}

struct JoinOrganizationPage_Previews: PreviewProvider {
    static var previews: some View {
        JoinOrganizationPage()
            .environmentObject(AppManager())
    }
}
