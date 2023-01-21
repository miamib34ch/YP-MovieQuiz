//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 30.10.2022.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading?
    private var movies: [MostPopularMovie] = []
    
    /*
     нужно на следующий спринт
     
     private let questions: [QuizQuestion] = [
     QuizQuestion(
     image: "The Godfather",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Dark Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Kill Bill",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Avengers",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false)
     ]
     */
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading?) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader?.loadMovies { result in
            // сетевые запросы работают не в основном потоке, но так как данные уже получены, то переходим в основной
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильмы в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    func requestNextQuestion() {
        // генерация следуещего вопроса
        
        // поскольку будем получать картинку через сетевой запрос, делаем это в другом потоке
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do { //пытаемся получить картинку и создать следующий вопрос
                imageData = try Data(contentsOf: movie.resizedImageURL)
                let rating = Float(movie.rating) ?? 0
                
                var correctAnswer = true //инициализация нужна, чтобы передать в функцию, значение будет изменено в следующей строчке
                let text = self.randomText(rating: rating, correctAnswer: &correctAnswer)
                
                
                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                
                //возвращаемся в главный поток, сетевые данные уже получены, работа с ними окончена
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {//если не получилось получить картинку, сообщаем об этом контроллеру
                print("Failed to load image")
                //возвращаемся в главный поток, сетевые данные не удалось получить, работа с ними окончена
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadImage()
                }
            }
        }
    }
    
    private func randomText(rating: Float, correctAnswer: inout Bool) -> String{
        let words = ["больше", "меньше"]
        if let word = words.randomElement(){
            if let number = (5..<10).randomElement(){
                let text = "Рейтинг этого фильма \(word) чем \(number)?"
                if word == "больше"{
                    correctAnswer = rating > Float(number)
                }
                else {
                    correctAnswer = rating < Float(number)
                }
                return text
            }
            else{
                if word == "больше"{
                    correctAnswer = rating > 7
                }
                else {
                    correctAnswer = rating < 7
                }
                return "Рейтинг этого фильма \(word) чем 7?"
            }
        }
        else {
            correctAnswer = rating > 7
            return "Рейтинг этого фильма больше чем 7?"
        }
    }
}
