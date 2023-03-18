//
//  UserModel.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 18/03/23.
//

import Foundation

struct UserProfileData: Codable {
    var invites : Invites?
    var likes   : Likes?
}


// Invites
struct Invites: Codable {
    var profiles            : [InvitedUser] = []
    var totalPages          : Int?
    var pendingInvitation   : Int?
    
    enum CodingKeys: String, CodingKey {
        case profiles, totalPages
        case pendingInvitation = "pending_invitations_count"
    }
}

struct InvitedUser: Codable {
    var details: GeneralInformation?
    var photos: [Photos] = []
    
    var selectedPhoto: Photos? {
        return photos.first(where: {$0.selected == true}) ?? photos.first
    }
    
    enum CodingKeys: String, CodingKey {
        case details = "general_information"
        case photos
    }
}

struct GeneralInformation: Codable {
    var firstName   : String?
    var age         : Int?
    
    var displayVal: String {
        var string = ""
        if let fname = firstName {
            string = "\(fname),"
        }
        if let _age = age {
            string += "\(_age)"
        }
        return string
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case age
    }
}

struct Photos: Codable {
    var photo       : String?
    var selected    : Bool?
}

// Likes
struct Likes: Codable {
    var profiles        : [User] = []
    var profileVisible  : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case profileVisible = "can_see_profile"
        case profiles
    }
}

struct User: Codable {
    var firstName   : String?
    var avatar      : String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case avatar
    }
}
