//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 13.11.2022.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject{ //без типа AnyObject weak не работает при создании объекта
    func showResult(alert: Alert?)
}
