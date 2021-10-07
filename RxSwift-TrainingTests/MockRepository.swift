import Foundation
@testable import RxSwift_Training

final class MockRepository: RepositoryType {
    var callCount: Int = 0
    var loginResult: Result<String, Error> = .success("token")
    
    func login(username: String, password: String, completion: (Result<String, Error>) -> Void) {
        callCount += 1
        completion(loginResult)
    }
}

enum MockError: Error {
    case mockError
}
