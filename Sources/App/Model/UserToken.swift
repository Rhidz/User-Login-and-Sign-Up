//
//  File.swift
//  
//
//  Created by Admin on 22/09/2021.

import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

// Dunno when to use it yet
extension UserToken: ModelTokenAuthenticatable {
    
    static var valueKey = \UserToken.$value
    static var userKey = \UserToken.$user
    
    var isValid: Bool {
        true
    }
}
