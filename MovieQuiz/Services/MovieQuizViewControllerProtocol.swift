//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 12.12.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func buttonsEnabled(isEnabled: Bool)
    
    func showNetworkDataError(message: String)
    func showNetworkImageError(message: String)
}
