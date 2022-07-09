//
//  PaginationViewModelDelegate.swift
//  Pagination
//
//  Created by Filipe Simoes Teodoro on 24/06/22.
//

import Foundation

protocol PaginationViewModelDelegate {
    func didSuccess(items: [Item])
    func didFailure(error: String)
}
