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
        /// cредняя точность (сумма всех результатов в виде - правильныеОтветы/общееКоличествоСыгранныхВопросов)
        case totalAccuracy 
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
            return userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
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
        
        let newGame: GameRecord = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        if bestGame < newGame {
            bestGame = newGame
        }
        
        //чтобы высчитать мы берём прошлое значение, умножаем на количество игр, которое было для этого-прошлого значения, так мы получаем общую сумму соотношений прошлых игр; затем добавляем соотношение новой игры и делим уже на текущие значение соотношений(количество сыгранных игр)
        totalAccuracy = (totalAccuracy*Double(gamesCount-1)+Double(count)/Double(amount))/Double(gamesCount)
    }
}
