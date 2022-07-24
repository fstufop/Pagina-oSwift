//
//  PaginationViewModel.swift
//  Pagination
//
//  Created by filipe.teodoro on 19/06/22.
//

import Foundation

class PaginationViewModel {
    // MARK: Properties
    private let service = PaginationService()
    private(set) var model: PaginationModel?
    private(set) var items: [Item] = []
    private var page: Int = 1
    var delegate: PaginationViewModelDelegate?
    var hasRequestInProgress: Bool = false
    
    // MARK: Methods
    func getDataPage(limit: Int) {
        guard !hasRequestInProgress else { return }
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
            self.delegate?.dismissLoading()
            self.hasRequestInProgress = false
        }
    }
    
    func getMoreData(limit: Int) {
        guard getNumberOfPages() >= self.page else { return }
        getDataPage(limit: limit)
    }
    
    func getNumberOfPages() -> Int {
        return model?.pagination.totalPages ?? 0
    }
    
    func refreshData() {
        page = 1
        items.removeAll()
    }
}
