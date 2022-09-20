//
//  AuthManager.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/09/04.
//

import Foundation

enum AuthError: Error {
    case badRequest // 400
    case unAuthorized // 401
    case serverError // 500 서버에러
    case invalidUID
    case invalidDeviceToken
    case invalidPassword
    case unexpected
}

class AuthManager {
    func hello() async throws -> Bool {
        guard let url = URL(string: URLPath.hello.URLString) else {
            return false
        }
        
        let (_, response) = try await URLSession.shared.data(from: url)
        
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    func signUp(userID: String, password: String, deviceToken: String) async throws -> Data {
        guard userID.count == 36 else {
            throw AuthError.invalidUID
        }
        
        guard password.count >= 10 && password.count <= 30  else {
            throw AuthError.invalidPassword
        }
        
        guard deviceToken.count == 64 else {
            throw AuthError.invalidDeviceToken
        }
        
        
        let dic = [
            "username" : userID,
            "password" : password,
            "deviceToken" : deviceToken
        ]
        let body = try JSONEncoder().encode(dic)
        
        
        var urlComponents = URLComponents(string: URLPath.signup.URLString)
        guard let url = urlComponents?.url else { return Data() }
        let defaultSession = URLSession(configuration: .default)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await defaultSession.upload(for: urlRequest, from: body)
        
        return data
    }
    
    func Authenticate(userName: String, password: String) async throws -> Data {
        guard userName.count == 36 else {
            throw AuthError.invalidUID
        }
        
        guard password.count >= 10 && password.count <= 30  else {
            throw AuthError.invalidPassword
        }
        
        let dic = [
            "username" : userName,
            "password" : password
        ]
        let body = try JSONEncoder().encode(dic)
        
        var urlComponents = URLComponents(string: URLPath.authenticate.URLString)
        guard let url = urlComponents?.url else { return Data() }
        let defaultSession = URLSession(configuration: .default)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await defaultSession.upload(for: urlRequest, from: body)
        
        return data
        
    }
    
    func pair(token: String, partnerName: String) async throws -> Data{
        guard partnerName.count == 36 else { throw AuthError.invalidUID }
        
        let dic = [
            "partnerName" : partnerName
        ]
        let body = try JSONEncoder().encode(dic)
        
        var urlComponents = URLComponents(string: URLPath.pair.URLString)
        guard let url = urlComponents?.url else { return Data() }
        let defaultSession = URLSession(configuration: .default)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await defaultSession.upload(for: urlRequest, from: body)
        
        return data
    }
    
    func queryAccount(bearer: String, token: String) async throws -> Data? {
        guard let url = URL(string: URLPath.account.URLString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(bearer, forHTTPHeaderField: "Bearer")
        urlRequest.addValue(token, forHTTPHeaderField: "Token")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if (response as? HTTPURLResponse)?.statusCode != 200 {
            throw AuthError.unexpected
        }
        
        return data
    }
}
