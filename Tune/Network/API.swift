
import Foundation
public struct API {
    var domain: String
    var path: String
    var method: RequestMethod
    var header:HeaderType
    
    init(domain: String = APIConstant.Domain.developer, path: String, method: RequestMethod = .post,headerType:HeaderType = .xWwwUrlEncode) {
        self.domain = domain
        self.path = path
        self.method = method
        self.header = headerType
    }
}

extension API {
    static let searchSong      = API(path: "/search", method: .get)//
}
