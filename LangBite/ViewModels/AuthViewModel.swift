//
//  AuthViewModel.swift
//  LangBite
//
//  Created by farenthigh on 24/11/2568 BE.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false // สถานะปัจจุบันของการล็อคอิน
    @Published var currentUser: UserData?
    @Published var errorMessage: String?
    
    let base_url = "http://127.0.0.1:3000/api/v1"
    
    var onLogin: ((Int) -> Void)?
    
    init() {
        self.currentUser = UserDefaults.standard.loadUser()
        }
    
    func Login(email: String, password: String) async throws -> LoginRes {
        let body = LoginReq(email: email, password: password)
        guard let url = URL(string: "\(base_url)/auth/login") else {
            print("Bad url:", "\(base_url)/auth/login")
            throw APIError.serverError(statusCode: 500)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Failed to encode request body:", error)
            throw APIError.serverError(statusCode: 500)
        }

        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Log response metadata
        if let http = response as? HTTPURLResponse {
//            print("HTTP status:", http.statusCode)
//            print("Response headers:", http.allHeaderFields)
        } else {
            print("Non-HTTP response:", response)
        }

        // Raw body for debugging
        let bodyString = String(data: data, encoding: .utf8) ?? "<non-utf8 data>"
//        print("Raw response body:", bodyString)

        // Check for HTTP error codes first
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            print("Server returned non-2xx status:", http.statusCode)
            // If server includes JSON error details, attempt to decode them for helpful logging
            if let maybeError = try? JSONDecoder().decode(LoginRes.self, from: data) {
                print("Decoded error response:", maybeError)
            }
            throw APIError.serverError(statusCode: http.statusCode)
        }

        // Decode
        do {
            let decoded = try JSONDecoder().decode(LoginRes.self, from: data)
            print("Decoded response:", decoded) // <--- you should see this on success
            // Interpret backend 'error' semantics:
            if let apiError = decoded.error, !apiError.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("API signalled error field:", apiError)
                throw APIError.serverError(statusCode: 500)
            }
            if let user = decoded.data {
                DispatchQueue.main.async {
                    UserDefaults.standard.saveUser(user)
                    self.currentUser = user
                    self.isLoggedIn = true
                }
            } else {
                self.errorMessage = decoded.error ?? "No user returned"
                self.isLoggedIn = false
            }
           
            return decoded
        } catch {
            print("Decoding failed:", error)
            print("Raw response again:", bodyString)
            throw APIError.decodingFailed
        }
    }
    func Register(username:String ,email: String, password: String) async throws -> RegisterRes {
        let body = RegisterReq(username: username,email: email, password: password)
        guard let url = URL(string: "\(base_url)/auth/register") else {
            print("Bad url:", "\(base_url)/auth/register")
            throw APIError.serverError(statusCode: 500)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Failed to encode request body:", error)
            throw APIError.serverError(statusCode: 500)
        }
        
        print("Fetch")
        // Perform request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Log response metadata
        if let http = response as? HTTPURLResponse {
            print("HTTP status:", http.statusCode)
            print("Response headers:", http.allHeaderFields)
        } else {
            print("Non-HTTP response:", response)
        }

        // Raw body for debugging
        let bodyString = String(data: data, encoding: .utf8) ?? "<non-utf8 data>"
        print("Raw response body:", bodyString)

        // Check for HTTP error codes first
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            print("Server returned non-2xx status:", http.statusCode)
            // If server includes JSON error details, attempt to decode them for helpful logging
            if let maybeError = try? JSONDecoder().decode(LoginRes.self, from: data) {
                print("Decoded error response:", maybeError)
            }
            throw APIError.serverError(statusCode: http.statusCode)
        }

        //Decode
        do {
            let decoded = try JSONDecoder().decode(RegisterRes.self, from: data)
            print("Decoded response:", decoded) // <--- you should see this on success
            // Interpret backend 'error' semantics:
            if let apiError = decoded.error, !apiError.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("API signalled error field:", apiError)
                throw APIError.serverError(statusCode: 500)
            }
            if let user = decoded.data {
                DispatchQueue.main.async {
                    UserDefaults.standard.saveUser(user)
                    self.currentUser = user
                    self.isLoggedIn = true
                }
            } else {
                self.errorMessage = decoded.error ?? "No user returned"
                self.isLoggedIn = false
            }
           
            return decoded
        } catch {
            print("Decoding failed:", error)
            print("Raw response again:", bodyString)
            throw APIError.decodingFailed
        }
    }
    func Logout() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isLoggedIn = false
        }
        UserDefaults.standard.clearUser()
    }
        
}
enum APIError: Error {
    case invalidURL
    case encodingFailed
    case invalidResponse
    case decodingFailed
    case unauthorized // 401
    case serverError(statusCode: Int)
}
