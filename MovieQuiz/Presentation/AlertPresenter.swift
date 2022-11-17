//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 07.11.2022.
//

import UIKit

struct AlertPresenter: AlertPresenterProtocol{
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?){
        self.delegate = delegate
    }
    
    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        guard let delegate = delegate else {return}
        
        delegate.present(alert, animated: true, completion: nil)
    }
}
