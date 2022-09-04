//
//  AuthManager.swift
//  POMPOM
//
//  Created by GOngTAE on 2022/09/04.
//

import Foundation

class AuthManager {
    func hello() {
        
    }
    
    func signUp(userID: String, password: String, deviceToken: String) async throws -> Data {
        guard userID.count == 36 else {
            return Data()
        }
        
        guard password.count >= 10 && password.count <= 30  else {
            return Data()
        }
        
        guard deviceToken.count == 64 else {
            return Data()
        }
        
        
        let dic = [
            "username" : userID,
            "password" : password,
            "deviceToken" : deviceToken
        ]
        let body = try JSONEncoder().encode(dic)
        
        
        var urlComponents = URLComponents(string: "https://pompom-ada.herokuapp.com/api/signup")
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
            return Data()
        }
        
        guard password.count >= 10 && password.count <= 30  else {
            return Data()
        }
        
        let dic = [
            "username" : userName,
            "password" : password
        ]
        let body = try JSONEncoder().encode(dic)
        
        var urlComponents = URLComponents(string: "https://pompom-ada.herokuapp.com/api/authenticate")
        guard let url = urlComponents?.url else { return Data() }
        let defaultSession = URLSession(configuration: .default)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await defaultSession.upload(for: urlRequest, from: body)
        
        return data
        
    }
    
    func pair(token: String, partnerName: String) async throws -> Data{
        guard partnerName.count == 36 else { return Data()}
        
        let dic = [
            "partnerName" : partnerName
        ]
        let body = try JSONEncoder().encode(dic)
        
        var urlComponents = URLComponents(string: "https://pompom-ada.herokuapp.com/api/pair")
        guard let url = urlComponents?.url else { return Data() }
        let defaultSession = URLSession(configuration: .default)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await defaultSession.upload(for: urlRequest, from: body)
        
        return data
    }
    
    func queryAccount() {
        
    }
}
