//
//  EmployeeRow.swift
//  Square
//
//  Created by MacDev1 on 2/8/23.
//

import SwiftUI

struct EmployeeRow: View {
    let item: Employee
    var body: some View {
        HStack{
            WebImageView(urlString: item.smallPhoto, imageIdentify: item.full_name, image: UIImage())
            VStack(alignment: .leading, spacing: 10){
                Text(item.full_name + " (" + item.team + ")").fontWeight(.bold)
                Text(item.biography).fontWeight(.light)
                Text(item.employee_type.description())
            }
        }
    }
}

struct EmployeeRow_Previews: PreviewProvider {
    static var previews: some View {

        EmployeeRow(item: Employee(uuid: "213124", full_name: "tester", phone_number: "3478356345", email_address: "tester@gmail.com", biography: "Engingeer", smallPhoto: "", largePhoto: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg", team: "Point of sale", employee_type: .CONTRACTOR))
    }
}
