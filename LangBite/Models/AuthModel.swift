//
//  AuthModel.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import Foundation


struct LoginReq: Codable {
    let email: String
    let password: String
}

struct LoginRes:Codable {
    let data: UserData?
    let message: String?
    let error: String?
}

struct UserData:Codable {
    let ID: Int?
    let username: String?
    let email: String?
    var avatar: String?
}

struct RegisterReq: Codable{
    let username: String
    let email: String
    let password: String
}
struct RegisterRes: Codable{
    let data: UserData?
    let message: String?
    let error: String?
}

struct UploadAvatarReq:Codable{
    let user_id: Int
    let avatar: String
}

struct UploadAvatarRes:Codable{
    let data: String?
    let error: String?
    let message: String
}
extension UserDefaults {
    func saveUser(_ user: UserData) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user) // encode to Data
            self.set(data, forKey: "USER_DATA") // store Data, safe!
        } catch {
            print("Failed to encode user:", error)
        }
    }

    func loadUser() -> UserData? {
        guard let data = self.data(forKey: "USER_DATA") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(UserData.self, from: data)
    }

    func clearUser() {
        self.removeObject(forKey: "USER_DATA")
    }
}
