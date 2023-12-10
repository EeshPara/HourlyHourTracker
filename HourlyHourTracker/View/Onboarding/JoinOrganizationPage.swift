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
    @State private var itemName = ""
    @State private var isExpanded = false
    @State private var selectedOrganization: Organization?
    @State private var color : Color = .black
    private var filteredItems: [Organization] {
            searchText.isEmpty ? organizations : organizations.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    var body: some View {
        NavigationStack
        {
            
            NavigationLink("", isActive: $navigate) {
                if manager.account.isOwner{
                    OrgOwnerPage()
                        .environmentObject(manager)
                } else if manager.account.isAdmin{
                    AdminPage()
                        .environmentObject(manager)
                }else{
                    StudentPage()
                        .environmentObject(manager)
                }
            }
            
            VStack
            {
                Text("Join an Organization")
                    .font(Font.custom("SF-Pro-Display-Bold", size: 40))
                    .foregroundColor(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical)
                    .font(Font.custom("SF-Pro-Display-Bold", size: 30))
                    .padding(.top)
                SearchBar(searchText: $searchText, color: $color, isExpanded: $isExpanded, itemName: $itemName)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                DisclosureGroup(
                                isExpanded: $isExpanded,
                                content: {
                                    VStack {
                                        
                                        if (filteredItems.isEmpty)
                                        {
                                            Text("No items found")
                                                .foregroundColor(.primary)
                                                .padding(.vertical, 8)
                                        }
                                        else
                                        {
                                            ForEach(filteredItems, id: \.self) { item in
                                                Button(action: {
                                                    selectedOrganization = item
                                                    isExpanded.toggle()
                                                    searchText = item.name
                                                    itemName = item.name
                                                    color = .blue
                                                    // Perform action when item is selected
                                                }) {
                                                    Text(item.name)
                                                        .foregroundColor(.primary)
                                                        .padding(.vertical, 8)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                                },
                                label: {
                                }
                )
                .frame(width: 308.0)
                
//                Text("OR")
//                    .foregroundColor(Color("burntsienna"))
                Spacer()
                Button {
                    if let selectedOrganization {
                        manager.account.organizationName = selectedOrganization.name
                        
                        manager.db.signUpUserGoogle(user: manager.account)
                        //nav to next View
                        navigate.toggle()
                    }
                    else{
                        print("select an organization")
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color("lightgrey2"), lineWidth: 1)
                                    .frame(width: 281, height: 65)
                        Text("Join")
                            .foregroundColor(Color("darkgrey"))
                            .font(Font.custom("SF-Pro-Display-Regular", size : 24))
                    }
                }
                .disabled(selectedOrganization == nil)
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
                print(" Error in Join Organization Page line 62 the Organization was nil")
            }
        }
    }
    
}
struct SearchBar: View {
    @Binding var searchText: String
    @Binding var color : Color
    @Binding var isExpanded : Bool
    @Binding var itemName : String
    var body: some View {
        TextField("Search", text: $searchText)
            .padding(.horizontal, 10)
            .frame(width: 308.0, height: 50.0)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(/*@START_MENU_TOKEN@*/Color("lightgrey1")/*@END_MENU_TOKEN@*/)
                    .opacity(0.5)
                )
            .foregroundColor(color)
            .onChange(of: searchText) { newValue in
                            if newValue != "" && !isExpanded && newValue != itemName{
                                isExpanded = true
                                color = .black
                            }
                        }
    }
}

struct JoinOrganizationPage_Previews: PreviewProvider {
    static var previews: some View {
        JoinOrganizationPage()
            .environmentObject(AppManager())
    }
}
