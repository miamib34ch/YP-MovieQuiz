//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Богдан Полыгалов on 22.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_vzyuj6z3") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    // MARK: - Loading movie and Errors
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesUrl){ result in // функция которая принимает ответ сетевого запроса (ошибка или дата)
            
            switch result{
            case .failure(let error):   // если приходит ошибка, то передаём её дальше
                handler(.failure(error))
                
            case .success(let data):    // приходят данные
                do {    // пытаемся их декодировать
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    
                    // декодировали, но данные пустые, тогда ошибка
                    if mostPopularMovies.items.isEmpty{
                        handler(.failure(loadingMovieError.loadError))
                        return
                    }
                    
                    // всё хорошо, передаём данные
                    handler(.success(mostPopularMovies))
                    
                } catch {// если не получилось, то передаём дальше ошибку ошибку
                    handler(.failure(loadingMovieError.loadError))
                }
            }
        }
    }
    
    private enum loadingMovieError: Error {
        case loadError
    }
}
