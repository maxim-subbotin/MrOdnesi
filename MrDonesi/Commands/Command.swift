//
//  Command.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 13.06.2022.
//

import Foundation
import Combine

public class Command<DataType: Codable, ErrorType: Codable> {
    public typealias Callback = (Result<DataType, Error>) -> ()
    enum Parameter {
        case int(param: Int, name: String)
        case string(param: String, name: String)
        case double(param: Double, name: String)
        
        var queryItem: URLQueryItem {
            switch self {
            case .int(let param, let name):
                return URLQueryItem(name: name, value: "\(param)")
            case .double(let param, let name):
                return URLQueryItem(name: name, value: "\(param)")
            case .string(let param, let name):
                return URLQueryItem(name: name, value: param)
            }
        }
    }
    public enum CommandError: Error {
        case incorrectUrlFormat(string: String)
        case serverError(_ error: ErrorType)
        case errorStatus(_ status: Int)
        case processingError(_ error: Error)
        case wrongResponse
    }
    
    private(set) var apiUrl: String
    private(set) var path: String
    var urlParametes = [Parameter]()
    var pathComponents = [String]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiUrl: String, path: String) {
        self.apiUrl = apiUrl
        self.path = path
    }
    
    public func fetchData(callback: @escaping Callback) {
        guard var url = URL(string: apiUrl) else {
            callback(.failure(CommandError.incorrectUrlFormat(string: apiUrl.appending("/").appending(path))))
            return
        }
        url.appendPathComponent(path)
        for component in pathComponents {
            url.appendPathComponent(component)
        }
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            callback(.failure(CommandError.incorrectUrlFormat(string: url.absoluteString)))
            return
        }
        urlComponents.queryItems = urlParametes.map({ $0.queryItem })
        guard let requestUrl = urlComponents.url else {
            callback(.failure(CommandError.incorrectUrlFormat(string: url.path)))
            return
        }
        // TODO: add support of POST, DELETE, PATCH etc methods
        URLSession.shared
            .dataTaskPublisher(for: requestUrl)
            .tryMap({ data, response in
                guard let status = (response as? HTTPURLResponse)?.statusCode else {
                    throw CommandError.wrongResponse
                }
                switch status {
                case (200...299):
                    return data
                default:
                    if let error = try? JSONDecoder().decode(ErrorType.self, from: data) {
                        throw CommandError.serverError(error)
                    }
                    throw CommandError.errorStatus(status)
                }
            })
            //.map({ $0.data })
            .decode(type: DataType.self, decoder: JSONDecoder())
            .mapError({ error -> CommandError in
                switch error {
                case is CommandError:
                    return error as! Command<DataType, ErrorType>.CommandError
                default:
                    return CommandError.processingError(error)
                }
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { res in
                switch res {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    callback(.failure(error))
                }
            }, receiveValue: { result in
                callback(.success(result))
            }).store(in: &cancellables)
    }
}
