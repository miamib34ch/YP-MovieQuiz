//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 07.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject { //без типа AnyObject weak не работает при создании объекта
    func didReceiveNextQuestion(question: QuizQuestion?)
}
