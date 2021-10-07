import Foundation

protocol RepositoryType {
    func login(username: String, password: String, completion: (Result<String, Error>) -> Void)
}

final class Repository: RepositoryType {
    func login(username: String, password: String, completion: (Result<String, Error>) -> Void) {
        
        completion(.success("token"))
    }
}
