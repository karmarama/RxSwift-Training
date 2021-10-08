import Foundation
import RxSwift

protocol LoginPresenterDelegate: AnyObject {
    func loginSuccess()
}

protocol LoginPresenterProtocol {
    // inputs:
    func loginAction()
    func usernameTextUpdated(text: String)
    func passwordTextUpdated(text: String)

    // outputs:
    var imageName: ReplaySubject<String> { get }
    var usernameTitle: ReplaySubject<String> { get }
    var usernameValue: ReplaySubject<String> { get }
    var passwordTitle: ReplaySubject<String> { get }
    var passwordValue: ReplaySubject<String> { get }
    var buttonTitle: ReplaySubject<String> { get }
    var errorTitle: ReplaySubject<String> { get }
    var isErrorHidden: ReplaySubject<Bool> { get }

    // delegate
    var delegate: LoginPresenterDelegate? { get set }
}

final class LoginPresenter: LoginPresenterProtocol {
    let imageName: ReplaySubject<String>
    let usernameTitle: ReplaySubject<String>
    let usernameValue: ReplaySubject<String>
    let passwordTitle: ReplaySubject<String>
    let passwordValue: ReplaySubject<String>
    let buttonTitle: ReplaySubject<String>
    let errorTitle: ReplaySubject<String>
    let isErrorHidden: ReplaySubject<Bool>

    weak var delegate: LoginPresenterDelegate?

    private let loginButtonAction = ReplaySubject<Void>.createUnbounded()
    private let username = ReplaySubject<String>.createUnbounded()
    private let password = ReplaySubject<String>.createUnbounded()
    private let bag = DisposeBag()

    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository

        // Won't change:
        imageName = ReplaySubject<String>.createUnbounded()
        imageName.onNext("login")
        usernameTitle = ReplaySubject<String>.createUnbounded()
        usernameTitle.onNext("Introduce your username")
        passwordTitle = ReplaySubject<String>.createUnbounded()
        passwordTitle.onNext("Introduce your password")
        buttonTitle = ReplaySubject<String>.createUnbounded()
        buttonTitle.onNext("Sign in")

        // Will change, with default value:
        isErrorHidden = ReplaySubject<Bool>.createUnbounded()
        isErrorHidden.onNext(true)

        // Will change, no value
        usernameValue = ReplaySubject<String>.createUnbounded()
        passwordValue = ReplaySubject<String>.createUnbounded()
        errorTitle = ReplaySubject<String>.createUnbounded()

        loginButtonAction
            .withLatestFrom(Observable.combineLatest(username, password))
            .subscribe { event in
                guard case let .next(latest) = event else { return }
                let (username, password) = latest

                print(username)
                print(password)

                // validate inputs
                if username.isEmpty || password.isEmpty {
                    self.errorTitle.onNext("Check your credentials")
                    self.isErrorHidden.onNext(false)
                } else {
                    // loading
                    self.isErrorHidden.onNext(true)

                    repository.login(username: username, password: password) { result in
                        // stop loading
                        switch result {
                        case .success:
                            self.delegate?.loginSuccess()
                            break
                        case .failure:
                            self.errorTitle.onNext("Can't not login")
                            self.isErrorHidden.onNext(false)
                        }
                    }
                }
            }
            .disposed(by: bag)
    }

    func usernameTextUpdated(text: String) {
        username.onNext(text)
    }

    func passwordTextUpdated(text: String) {
        password.onNext(text)
    }

    func loginAction() {
        loginButtonAction.onNext(())
    }
}
