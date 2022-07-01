
import Foundation
import Moya


private struct Target: TargetType {
    init(request: Requset) {
        self.request = request
    }
    var request: Requset
    var baseURL: URL {
        return URL(string: request.baseURL)!
    }
    var path: String {
        return request.path
    }
    
    var method: Moya.Method {
        switch request.method {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
    
    var sampleData: Data = "".data(using: .utf8)!
    
    var task: Task {

        if(request.headerType == .json){
            switch request.method {
            case .get:
                return .requestParameters(parameters: request.parameters, encoding: URLEncoding.queryString)
            case .put , .post:
                return .requestParameters(parameters: request.parameters, encoding: JSONEncoding.default)
            case .delete:
                return .requestParameters(parameters: request.parameters, encoding: URLEncoding.default)
            }
        }else if(request.headerType == .formData){
            var multipartData = [MultipartFormData]()
            for (key, value) in request.parameters {
                if let uploadData = value as? (Data,String,String,String) {
                    let imageData = MultipartFormData(provider: .data( uploadData.0), name: uploadData.3, fileName: uploadData.1, mimeType: uploadData.2)
                    multipartData.append(imageData)
                }else{
                    let formData = MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key)
                    multipartData.append(formData)
                }
            }

            return .uploadMultipart(multipartData)
        }
        else{
            return .requestParameters(parameters: request.parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {

        if(request.headerType == .json){
            return ["Content-Type":"application/json; charset=utf-8","Apikey":""]
        }
        else if(request.headerType == .formData){
            return ["Content-Type":"multipart/form-data","Apikey":""]
        }
        else{
            return ["Content-Type":"application/x-www-form-urlencoded","Apikey":""]
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager("")
    init(_ baseURL: String = "") {
        self.baseUrl = baseURL
    }
    var baseUrl = ""
    func post(path: String,params: [String: Any]?,result: @escaping ((Result<Response,Error>)->()),headerType:HeaderType){
        var request = Requset(baseURL:baseUrl, path: path, parameters: params)
        request.method = .post
        request.headerType = headerType
        let target = Target(request: request)
        self.request(target: target, result: result)
    }
    func get(path: String,params: [String: Any]?,result: @escaping ((Result<Response,Error>)->()),headerType:HeaderType){
        var request = Requset(baseURL:baseUrl, path: path, parameters: params)
        request.method = .get
        request.headerType = headerType
        let target = Target(request: request)
        self.request(target: target, result: result)
    }
    func put(path: String,params: [String: Any]?,result: @escaping ((Result<Response,Error>)->()),headerType:HeaderType){
        var request = Requset(baseURL:baseUrl, path: path, parameters: params)
        request.method = .put
        request.headerType = headerType
        let target = Target(request: request)
        self.request(target: target, result: result)
    }
    func delete(path: String,params: [String: Any]?,result: @escaping ((Result<Response,Error>)->()),headerType:HeaderType){
        var request = Requset(baseURL:baseUrl, path: path, parameters: params)
        request.method = .delete
        request.headerType = headerType
        let target = Target(request: request)
        self.request(target: target, result: result)
    }
    private func request(target: Target,result: @escaping ((Result<Response,Error>)->())) {
        MoyaProvider<Target>().request(target, progress: { progress in

        }) { res in
            switch res {
            case .success(let success):
                result(.success(success))
            case .failure(let err):
                result(.failure(err))
            }

        }
    }
}
