//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 22.11.2022.
//

import Foundation

/// отвечает за загрузку данных по URL
struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error)) // вызывается функция handler и в неё передаётся ассоциированный кейс перечисления Result
                return
            }
            
            // проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // возвращаем данные
            guard let data = data else { return }
            handler(.success(data)) // вызывается функция handler и в неё передаётся ассоциированный кейс перечисления Result
        }
        
        task.resume()
    }
}
