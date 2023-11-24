//
//  TransactionDetailsViewController.swift
//  iOSGenesisSample
//

import UIKit
import GenesisSwift

protocol CellDidChangeDelegate: AnyObject {
    func cellTextFieldDidChange(value: Any, indexPath: IndexPath)
    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField)
    func cellTextFieldValidationPassed(_ indexPath: IndexPath)
}

final class TransactionDetailsViewController: UIViewController {

    var transactionName: TransactionName? {
        didSet {
            if let name = transactionName {
                inputData = InputData(transactionName: name)
            } else {
                assertionFailure("TransactionName must be set")
            }
        }
    }
    weak var configurationData: ConfigurationData!

    @IBOutlet private weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!

    private var inputData: InputData!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

private extension TransactionDetailsViewController {

    var data: [GenesisSwift.DataProtocol] {
        inputData.objects
    }

    @objc func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }

    @objc func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }

    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        guard isViewVisible() else { return }

        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        guard let curve = UIView.AnimationCurve(rawValue: curveValue) else { return }

        let convertedKeyboardFrame = view.convert(keyboardFrameValue, from: view.window)

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            self.bottomLayoutConstraint.constant = self.view.bounds.maxY - convertedKeyboardFrame.minY + 8
            self.view?.layoutIfNeeded()
        }
        animator.startAnimation()
    }

    func showPayForm() {

        let configuration = configurationData.createConfiguration()
        let paymentRequest = inputData.createPaymentRequest()

        // Init Genesis with Configuration and PaymentRequest
        let genesis = Genesis(withConfiguration: configuration, paymentRequest: paymentRequest, forDelegate: self)

        // show Genesis payment form
        // Push to navigation controller
        genesis.push(toNavigationController: navigationController!, animated: true)

        // Present to modal view
        // genesis.present(toViewController: self, animated: true)

        // Use genesis.genesisViewController() and show how you want
        // guard let genesisViewController = genesis.genesisViewController() else {
        //    return
        // }
        // show(genesisViewController, sender: nil)
    }
}

// MARK: - UITableViewDataSource
extension TransactionDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data.count {
            return tableView.dequeueReusableCell(withIdentifier: "PayTableViewCell", for: indexPath)
        } else {
            let rowData = data[indexPath.row]

            if let data = rowData as? PickerData {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as? PickerTableViewCell).unwrap()
                cell.data = data
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            } else {
                let cell = (tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as? InputTableViewCell).unwrap()
                cell.data = rowData
                cell.indexPath = indexPath
                cell.delegate = self

                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension TransactionDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == data.count {
            guard inputData.amount.value.explicitConvertionToDecimal() != nil else {
                presentAlertWithTitle("Amount error")
                return
            }

            showPayForm()
        }
    }
}

// MARK: - GenesisDelegate
extension TransactionDetailsViewController: GenesisDelegate {
    func genesisDidFinishLoading() {
        // empty
    }

    func genesisDidEndWithSuccess() {
        presentAlertWithTitle("Success", andMessage: "Success transaction")
    }

    func genesisDidEndWithFailure(errorCode: GenesisError) {
        let code = errorCode.code ?? "unknown"
        let technical = errorCode.technicalMessage ?? "unknown"
        let message = errorCode.message ?? "unknown"
        let details = "code: \(code)\n technical: \(technical)\n message: \(message)"
        presentAlertWithTitle("Failure", andMessage: details)
    }

    func genesisDidEndWithCancel() {
        presentAlertWithTitle("Canceled")
    }

    func genesisValidationError(error: GenesisValidationError) {
        print(error.errorUserInfo)
        presentAlertWithTitle("SDK Validation error", andMessage: error.localizedDescription)
    }
}

// MARK: - CellDidChangeDelegate
extension TransactionDetailsViewController: CellDidChangeDelegate {

    func cellTextFieldDidChange(value: Any, indexPath: IndexPath) {
        var dataObject = data[indexPath.row]
        if let value = value as? String {
            dataObject.value = value

            inputData.save()

            switch InputData.Titles(rawValue: dataObject.title) {
            case .recurringMode, .payLater:
                tableView.reloadData()
            default:
                break
            }
        }
    }

    func cellTextFieldValidationError(_ indexPath: IndexPath, textField: UITextField) {
        textField.becomeFirstResponder()
        presentAlertWithTitle("Validation error", andMessage: "for: \(data[indexPath.row].title)")
    }

    func cellTextFieldValidationPassed(_ indexPath: IndexPath) {
        // empty
    }
}
