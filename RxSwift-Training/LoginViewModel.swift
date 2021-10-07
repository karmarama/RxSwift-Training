import RxSwift
import Foundation

protocol LoginViewModelInputsType {
    var loginRelay: BehaviorSubject<Void> { get }
}

protocol LoginViewModelOutputsType {
    var image: Observable<String> { get }
    var usernameTitle: Observable<String> { get }
    var passwordTitle: Observable<String> { get }
    var buttonTitle: Observable<String> { get }
    var errorLabel: Observable<String> { get }
    var errorIsHidden: Observable<Bool> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInputsType { get }
    var outputs: LoginViewModelOutputsType { get }
}


final class LoginViewModel: LoginViewModelType,
                            LoginViewModelInputsType, LoginViewModelOutputsType {
    
    var inputs: LoginViewModelInputsType { self }
    var outputs: LoginViewModelOutputsType { self }
    
    let image: Observable<String>
    let usernameTitle: Observable<String>
    let passwordTitle: Observable<String>
    let buttonTitle: Observable<String>
    let errorLabel: Observable<String>
    let errorIsHidden: Observable<Bool>
    
    let username = BehaviorSubject<String?>(value: nil)
    let password = BehaviorSubject<String?>(value: nil)
    let loginRelay = BehaviorSubject<Void>(value: ())
    
    private let repository: RepositoryType
    private let bag = DisposeBag()
    
    init(repository: RepositoryType) {
        self.repository = repository
        
        image = .just("login")
        usernameTitle = .just("Introduce your username")
        passwordTitle = .just("Introduce your password")
        buttonTitle = .just("login")
        
        errorLabel = .just("")
        errorIsHidden = .just(true)
        
        loginRelay
            .withLatestFrom(Observable.combineLatest(username, password))
            .subscribe { event in
                guard case let .next(value) = event else { return }
                let (username, password) = value
                print(username)
                print(password)
                //        // validate inputs
                //        if username.isEmpty || password.isEmpty {
                //            view?.set(errorLabel: "Check your credentials")
                //            view?.set(errorIsHidden: false)
                //        } else {
                //            // loading
                //            view?.set(errorIsHidden: true)
                //
                //            repository.login(username: username, password: password) { result in
                //                // stop loading
                //                switch result {
                //                case .success:
                //                    // push
                //                    break
                //                case .failure:
                //                    view?.set(errorLabel: "Can't not login")
                //                    view?.set(errorIsHidden: false)
                //                }
                //            }
                //        }
            }
            .disposed(by: bag)
    }
}
