//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 14.11.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int //количество правильных ответов
    let total: Int //количество вопросов квиза
    let date: String //дата завершения раунда
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
       lhs.correct < rhs.correct
    }
}
