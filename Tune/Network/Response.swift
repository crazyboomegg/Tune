
import HandyJSON
import Foundation

public struct DataResponse<T>: RequestProtocol where T: HandyJSON {
    public init (){}
    public var status: String = ""
    public var errorMessage: String = ""
    public var results: T?
}
public struct ListResponse<T>: RequestProtocol where T: HandyJSON {
    public init (){}
    public var status: String = ""
    public var errorMessage: String = ""
    public var results: [T] = []
}
public struct MsgResponse<T>:  RequestProtocol {
    public init (){}
    public var status: String = ""
    public var errorMessage: String = ""
    public var results: T?
}


