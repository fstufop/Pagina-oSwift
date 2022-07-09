//
//  PaginationViewModel.swift
//  Pagination
//
//  Created by Filipe Simoes Teodoro on 24/06/22.
//

import Foundation

final class PaginationViewModel {
    // MARK: Properties
    private var model: PaginationModel?
    private let service = PaginationService()
    private var page: Int = 1
    private(set) var items: [Item] = []
    var delegate: PaginationViewModelDelegate?
    var hasRequestInProgress: Bool = false
    // MARK: Service
    func getData(limit: Int) {
        guard !hasRequestInProgress else {return}
        hasRequestInProgress = true
        service.request(page: page.description, limit: limit.description) { response in
            switch response {
            case .success(let model):
                self.model = model
                self.items.append(contentsOf: model.data)
                self.delegate?.didSuccess(items: self.items)
                self.page += 1
            case .failure(let error):
                self.delegate?.didFailure(error: error.localizedDescription)
            }
            self.hasRequestInProgress = false
        }
    }
    
    func getMoreData(limit: Int) {
        guard 4 >= self.page else { return }
        getData(limit: limit)
    }
    
    func getNumberOfPages() -> Int {
        return model?.pagination.totalPages ?? 0
    }
    
    func getCurrentPage() -> Int {
        return model?.pagination.currentPage ?? 0
    }
}
