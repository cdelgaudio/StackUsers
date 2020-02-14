//
//  NetworkManager.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case parsing(description: String)
    case network(description: String)
    case urlSerialization
}

protocol Networkable: class {
    func getImage(
        path: String,
        completion: @escaping NetworkCompletion<Data>
    ) -> URLSessionDownloadTask?
    
    func getUsers(
        numberOfUsers: Int,
        completion: @escaping NetworkCompletion<UsersResponse>
    ) -> URLSessionDataTask?
    
}

typealias NetworkCompletion<T> = (Result<T, NetworkError>) -> Void


final class NetworkManager: Networkable {
    
    static let shared: NetworkManager = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        session = URLSession.shared
    }
    
    @discardableResult
    func getImage(
        path: String,
        completion: @escaping NetworkCompletion<Data>
    ) -> URLSessionDownloadTask? {
        guard let url = URL(string: path) else {
            completion(.failure(.urlSerialization))
            return nil
        }
        let task = session.dataDownloadTask(url: url, completion: completion)
        task.resume()
        return task
    }
    
    @discardableResult
    func getUsers(
        numberOfUsers: Int,
        completion: @escaping NetworkCompletion<UsersResponse>
    ) -> URLSessionDataTask? {
        guard let url = ApiRequest.users(number: numberOfUsers).url else {
            completion(.failure(.urlSerialization))
            return nil
        }
        let task = session.codableTask(with: url, completion: completion)
        task.resume()
        return task
    }
}

extension URLSession {
    fileprivate func codableTask<T: Decodable>(
        with url: URL,
        completion: @escaping NetworkCompletion<T>
    ) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.network(description: error?.localizedDescription ?? "No data")))
                return
            }
            do {
                completion(.success(try JSONDecoder().decode(T.self, from: data)))
            } catch {
                completion(.failure(.parsing(description: error.localizedDescription)))
            }
        }
    }
    
    fileprivate func dataDownloadTask(
        url: URL,
        completion: @escaping NetworkCompletion<Data>
    ) -> URLSessionDownloadTask {
        return self.downloadTask(with: url) { (path, response, error) in
            guard let path = path else {
                completion(.failure(.network(description: error?.localizedDescription ?? "No Path")))
                return
            }
            do {
                completion(.success(try Data(contentsOf: path)))
            } catch {
                completion(.failure(.parsing(description: error.localizedDescription)))
            }
        }
    }
}
