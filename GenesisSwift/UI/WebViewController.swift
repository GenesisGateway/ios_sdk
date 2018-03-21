//
//  GenesisViewController.swift
//  GenesisSwift
//

import UIKit

public final class GenesisViewController: UIViewController {

    lazy var indicator: UIActivityIndicatorView = {
        let indi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indi.color = UIColor.black
        indi.hidesWhenStopped = true
        
        self.view.addSubview(indi)
        indi.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indi.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indi.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
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
        
        indicator.startAnimating()
        
        self.setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.white

        if let navigationController = self.navigationController {
            navigationController.navigationBar.isTranslucent = false
        }
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
