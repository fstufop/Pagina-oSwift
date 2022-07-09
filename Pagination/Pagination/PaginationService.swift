//
//  PaginationService.swift
//  Pagination
//
//  Created by filipe.teodoro on 19/06/22.
//

import Foundation

class PaginationService {
    func request(page: String,
                 limit: String,
                 completion: @escaping ((Result<PaginationModel,Error>) -> Void)) {
        let urlString = "https://api.artic.edu/api/v1/artworks?page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            print(response.statusCode)
            
            guard let data = data else { return }
            
            do {
                let model = try JSONDecoder().decode(PaginationModel.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
