//
//  ContentView.swift
//  Square
//
//  Created by MacDev1 on 2/8/23.
//

import SwiftUI

struct ContentView: View {
    @State var employees:Employees = []
    @State var showingAlert = false
    @State var alertMessage = ""
    
    init(){
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        NavigationView{
            Group{
                if employees.isEmpty {
                    GeometryReader { geometry in
                        ScrollView {
                            Text("No Data")
                                .multilineTextAlignment(.center)
                                .padding()
                                .position(x: geometry.size.width/2, y:geometry.size.height/2)
                        }
                    }
                }else{
                    List{
                        ForEach(employees) { employee in
                            EmployeeRow(item: employee)
                        }
                    }
                }
            }
            .navigationTitle("Square(from Bruno)")
            .alert(alertMessage, isPresented: $showingAlert, actions: {})
            .onAppear{
                refreshMembers(request: RequestManager.REQUEST_ACTION.ACTION_FETCH, result: {_,_  in })
            }
            .refreshable{
                refreshMembers(request: RequestManager.REQUEST_ACTION.ACTION_FETCH, result: {_,_ in })
            }
        }
    }
    func refreshMembers(request: RequestManager.REQUEST_ACTION, result:@escaping (Bool, Int) -> ()){
        RequestManager().fetchUsers(request: request) { array in
            self.employees = array.sorted(by: {(s1, s2) -> Bool in return s1.team < s2.team})
            result(true, array.count)
        } failure: { requestErr in
            switch requestErr {
                case .invalidURL:
                    alertMessage = "You called invalid rest api point"
                    showingAlert = true
                    break
                case .invalidRequest(onAction: let onAction, errorMsg: let errorMsg):
                    alertMessage = "You get error on during \(onAction[]) with error: \(errorMsg)"
                    showingAlert = true
                    break
                case .invalidResponse(onAction: let onAction):
                    alertMessage = "You get error on during \(onAction[]) with JSON PARSING ERROR"
                    showingAlert = true
                    break
            }
            result(false, 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
