import RxCocoa
import RxSwift
import UIKit

protocol LoginView: AnyObject {
    func set(image: String)
    func set(username: String)
    func set(password: String)
    func set(buttonTitle: String)
    func set(errorLabel: String)
    func set(errorIsHidden: Bool)
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var usernameTitle: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTitle: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private let bag = DisposeBag()
    
    var viewModel: LoginViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel.outputs)
        bind(viewModel.inputs)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    init() {
        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: LoginViewController.self))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ outputs: LoginViewModelOutputsType) {
        outputs
            .image
            .map(UIImage.init(named:))
            .bind(to: image.rx.image)
            .disposed(by: bag)
        outputs
            .usernameTitle
            .bind(to: usernameTitle.rx.text)
            .disposed(by: bag)
    }
    
    private func bind(_ inputs: LoginViewModelInputsType) {
        loginButton.rx.tap
            .bind(to: inputs.loginRelay)
            .disposed(by: bag)
    }
    
    @IBAction func usernameEditingChanged(_ sender: Any) {
        
    }
    @IBAction func passrwordEditingChanged(_ sender: Any) {
        
    }
    @IBAction func loginTouchUpInside(_ sender: Any) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
