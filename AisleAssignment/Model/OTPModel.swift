//
//  OTPModel.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import Foundation

struct PhoneNumberModel : Codable {
    var status : Bool?
}

struct OTPModel : Codable {
    var token : String?
}
