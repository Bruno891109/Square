//
//  Employee.swift
//  Square
//
//  Created by MacDev1 on 2/8/23.
//

import Foundation

struct DummyCodable: Codable {}

struct Employee: Codable, Identifiable {
    var id = UUID()
  
    enum EmployeeType: String, Codable{
        case FULL_TIME
        case PART_TIME
        case CONTRACTOR
        
        func description() -> String {
            switch self{
            case .FULL_TIME:
                return "Full Time Contract"
            case .PART_TIME:
                return "Part Time Contract"
            case .CONTRACTOR:
                return "W2 Contract"
            }
        }
    }
    
    var uuid: String
    var full_name: String
    var phone_number: String
    var email_address: String
    var biography: String
    var smallPhoto: String
    var largePhoto: String
    var team: String
    var employee_type: EmployeeType
    
    enum CodingKeys: String, CodingKey {
        case uuid, full_name, phone_number, email_address, biography
        case smallPhoto = "photo_url_small"
        case largePhoto = "photo_url_large"
        case team, employee_type
    }
}

extension Employee {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid) ?? ""
        id = UUID(uuidString: uuid) ?? UUID()
        full_name = try values.decodeIfPresent(String.self, forKey: .full_name) ?? ""
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number) ?? ""
        email_address = try values.decodeIfPresent(String.self, forKey: .email_address) ?? ""
        biography = try values.decodeIfPresent(String.self, forKey: .biography) ?? ""
        smallPhoto = try values.decodeIfPresent(String.self, forKey: .smallPhoto) ?? ""
        largePhoto = try values.decodeIfPresent(String.self, forKey: .largePhoto) ?? ""
        team = try values.decodeIfPresent(String.self, forKey: .team) ?? ""
        employee_type = try values.decodeIfPresent(EmployeeType.self, forKey: .employee_type) ?? .CONTRACTOR
    }
}

typealias Employees = [Employee]
