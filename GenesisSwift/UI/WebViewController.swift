//
//  GenesisViewController.swift
//  GenesisSwift
//

import UIKit

public final class GenesisViewController: UIViewController {

    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indi = UIActivityIndicatorView(style: .whiteLarge)
        indi.color = .black
        indi.hidesWhenStopped = true

        view.addSubview(indi)
        indi.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indi.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indi.centerYAnchor.constraint(equalTo: view.centerYAnchor)])

        return indi
    }()

    public func back(animated: Bool) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        indicator.startAnimating()
    }

    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }

    func addView(_ newView: UIView) {
        view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            newView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            newView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            newView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)])
    }
}
