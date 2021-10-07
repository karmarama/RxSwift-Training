import Foundation

protocol LoginPresenterProtocol {
    func viewDidLoad()
    func attachView(_ view: LoginView)
    func set(username: String)
    func set(password: String)
    func loginAction()
}

final class LoginPresenter {
    private weak var view: LoginView?
    private var username: String = ""
    private var password: String = ""

    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
}

extension LoginPresenter: LoginPresenterProtocol {

    func attachView(_ view: LoginView) {
        self.view = view
    }
    func viewDidLoad() {
        view?.set(image: "login")
        view?.set(username: "Introduce your username")
        view?.set(password: "Introduce your password")
        view?.set(buttonTitle: "Sign in")
        view?.set(errorIsHidden: true)
    }
    func set(username: String) {
        self.username = username
    }
    func set(password: String) {
        self.password = password
    }
    func loginAction() {
        print(username)
        print(password)
        // validate inputs
        if username.isEmpty || password.isEmpty {
            view?.set(errorLabel: "Check your credentials")
            view?.set(errorIsHidden: false)
        } else {
            // loading
            view?.set(errorIsHidden: true)
            
            repository.login(username: username, password: password) { result in
                // stop loading
                switch result {
                case .success:
                    // push
                    break
                case .failure:
                    view?.set(errorLabel: "Can't not login")
                    view?.set(errorIsHidden: false)
                }
            }
        }
    }
}
