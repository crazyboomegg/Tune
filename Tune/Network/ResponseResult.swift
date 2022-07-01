
import Foundation
public enum ResponseError: Error {
    case deserializeFailed
    case requestFailed
    case emptyDataFailed
}
public enum ResponseResult<Value> {
    case success(Value)
    case failure(ResponseError)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: ResponseError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
