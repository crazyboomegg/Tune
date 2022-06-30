
import Foundation
enum RequestMethod {
    case post
    case get
    case put
    case delete
}

enum HeaderType {
    case xWwwUrlEncode
    case json
    case formData
}

struct Requset {
    init(method: RequestMethod = .post, baseURL: String = "", path: String, parameters: [String : Any]?){
        self.method = method
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters ?? [:]
        self.headerType = .xWwwUrlEncode
    }
    
    var method: RequestMethod
    var baseURL: String
    var path: String
    var parameters: [String: Any]
    var headerType:HeaderType
}
