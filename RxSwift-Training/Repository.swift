import Foundation
import RxSwift

protocol RepositoryType {
    func login(username: String, password: String) -> Observable<String>
}

final class Repository: RepositoryType {
    func login(username: String, password: String) -> Observable<String> {
            .just("token")
    }
}
