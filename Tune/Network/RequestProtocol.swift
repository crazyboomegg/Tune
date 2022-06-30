
import Foundation
import HandyJSON
import Moya

public protocol RequestProtocol: HandyJSON {
    static func request(api: API, params: [String: Any]?, result: ((ResponseResult<Self>)->())?)
}

public extension RequestProtocol where Self: HandyJSON {
    static func request(api: API, params: [String: Any]?, result: ((ResponseResult<Self>)->())?) {
        let completionHandle: ((Result<Response,Error>)->()) = { res in
            switch res {
            case .success(let res):


                let data = res.data
                let jsonStr = String(data: data, encoding: .utf8)
                #if DEBUG
                print("url: \(api.path)")
                print("params: \(String(describing: params))")
                print("jsonStr: \(jsonStr ?? "")")
                #endif
                guard let jsonObj = self.self.deserialize(from: jsonStr) else {
                    result?(.failure(.deserializeFailed))
                    return
                }
                
                result?(.success(jsonObj))
            case .failure(_):
                result?(.failure(.requestFailed))
            }
        }
        NetworkManager.shared.baseUrl = api.domain
        switch api.method {
        case .get:
            print(NetworkManager.shared.baseUrl)
            NetworkManager.shared.get(path: api.path, params: params, result: completionHandle, headerType: api.header)
        case .post:
            print(NetworkManager.shared.baseUrl)
            NetworkManager.shared.post(path: api.path, params: params, result: completionHandle, headerType: api.header)
        case .put:
            NetworkManager.shared.put(path: api.path, params: params, result: completionHandle, headerType: api.header)
        case .delete:
            NetworkManager.shared.delete(path: api.path, params: params, result: completionHandle, headerType: api.header)
        }
    }
}
