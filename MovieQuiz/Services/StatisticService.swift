//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 14.11.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {

    private let userDefaults = UserDefaults.standard //хранилище данных
    
    private enum Keys: String { //ключи для хранилища
        /// количество сыгранных вопросов за всё время
        case totals
        /// количество правильных ответов за всё время
        case corrects
        /// лучшая игра: результат и дата
        case bestGame 
         /// общее количество игр
        case gamesCount
    }
    
    var bestGame: GameRecord{
        get{
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date().dateTimeString)
            }
            
            return record
        }
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get{
            let corrects = userDefaults.integer(forKey: Keys.corrects.rawValue)
            let totals = userDefaults.integer(forKey: Keys.totals.rawValue)
            return Double(corrects)/Double(totals)
        }
    }
    
    var gamesCount: Int {
        get{
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        //сохраняем рекорд если побили
        let newGame: GameRecord = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        if bestGame < newGame {
            bestGame = newGame
        }
        
        //сохраняем количество правильных ответов за всё время
        var corrects = userDefaults.integer(forKey: Keys.corrects.rawValue)
        corrects += count
        userDefaults.set(corrects, forKey: Keys.corrects.rawValue)
        
        //сохраняем количество сыгранных вопросов за всё время
        var totals = userDefaults.integer(forKey: Keys.totals.rawValue)
        totals += amount
        userDefaults.set(totals, forKey: Keys.totals.rawValue)
        
    }
}
