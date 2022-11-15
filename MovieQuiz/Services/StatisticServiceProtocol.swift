//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 14.11.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get } //средняя точность
    var gamesCount: Int { get } //количество игр за всё время
    var bestGame: GameRecord { get } //лучшая игра: результат и дата
    
    func store(correct count: Int, total amount: Int) //метод сохранения текущего результата игры
}
