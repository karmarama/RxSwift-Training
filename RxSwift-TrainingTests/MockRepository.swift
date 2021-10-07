import Foundation
@testable import MVVM_Refactored
import RxSwift

final class MockRepository: RepositoryType {
    var callCount: Int = 0
    var loginResult: String?
    
    func login(username: String, password: String) -> Observable<String> {
        callCount += 1
        if let loginResult = loginResult {
            return .just(loginResult)
        } else {
            return Observable.error(MockError.mockError)
        }
    }
}

enum MockError: Error {
    case mockError
}
