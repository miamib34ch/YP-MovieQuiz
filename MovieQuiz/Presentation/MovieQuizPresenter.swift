//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 12.12.2022.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    
    private let questionsAmount: Int = 10 // лимит вопросов в игре
    private var currentQuestionIndex: Int = 0 // номер текущего вопроса
    private var currentQuestion: QuizQuestion? // текущий вопрос
    private var correctAnswers: Int = 0 // количество правильных ответов
    
    private var statisticService: StatisticService? // "какая-то" статистика, которая соответствует протоколу
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    var questionFactory: QuestionFactoryProtocol? // "какая-то" фабрика вопросов, которая соответствует протоколу
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        // подтягиваем сервис статистики
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers) из \(questionsAmount)",
                buttonText: "Сыграть ещё раз")
            statisticService?.store(correct: correctAnswers, total: questionsAmount) // сохраняем статистику
            viewController?.show(quiz: viewModel)
        } else {
            switchToNextQuestion()
            viewController?.showLoadingIndicator() // показываем индикатор загрузки поскольку картинки грузятся
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        // подсчёт очков
        didAnswer(isCorrectAnswer: isCorrect)
        
        // ограничиваем работу кнопок на время загрузки данных
        viewController?.buttonsEnabled(isEnabled: false)
        
        // показываем рамку правильного или неправильного ответов
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        // через секунду показываем следующий вопрос и разрешаем работу кнопок
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func makeResultsMessage() -> String {
        var resultMessage = ""
        
        // добавлением статистику
        if let statisticService = statisticService {
            let count = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            
            let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date))"
            
            let accuracy = "Средняя точность \(String(format: "%.2f", statisticService.totalAccuracy*100))%"
            
            resultMessage = "\n" + count + "\n" + record + "\n" + accuracy
        }
        
        return resultMessage
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.viewController?.hideLoadingIndicator() // скрываем индикатор загрузки
            self.viewController?.buttonsEnabled(isEnabled: true) //делаем кнопки доступными
            self.viewController?.show(quiz: viewModel) // показываем вопрос
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkDataError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    func didFailToLoadImage() {
        viewController?.showNetworkImageError(message: "Не удаётся загрузить картинку")
    }
    
}
