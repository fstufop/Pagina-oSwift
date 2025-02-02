//
//  PaginationViewController.swift
//  Pagination
//
//  Created by Filipe Simoes Teodoro on 24/06/22.
//

import UIKit

class PaginationViewController: UIViewController {
    // MARK: Properties
    private let viewModel = PaginationViewModel()
    private let refreshControl = UIRefreshControl()
    private var items: [Item] = []
    private lazy var loading = UIActivityIndicatorView(style: .medium)
    private lazy var viewInformation: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelInformations: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getDataPage(limit: 50)
        setupUI()
    }

    // MARK: Setups
    private func setupUI() {
        view.backgroundColor = .gray
        view.addSubview(tableView)
        viewInformation.addSubview(labelInformations)
        view.addSubview(viewInformation)
        setupViewInformation()
        setupTableView()
        setupLabel()
        updateInformations()
        setupRefreshControl()
    }
    
    private func setupViewInformation() {
        viewInformation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        viewInformation.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewInformation.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewInformation.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupLabel() {
        labelInformations.topAnchor.constraint(equalTo: viewInformation.safeAreaLayoutGuide.topAnchor).isActive = true
        labelInformations.leadingAnchor.constraint(equalTo: viewInformation.leadingAnchor, constant: 16).isActive = true
        labelInformations.trailingAnchor.constraint(equalTo: viewInformation.trailingAnchor, constant: -16).isActive = true
        labelInformations.bottomAnchor.constraint(equalTo: viewInformation.bottomAnchor).isActive = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.topAnchor.constraint(equalTo: viewInformation.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc
    private func refresh(_ sender: AnyObject) {
        items.removeAll()
        viewModel.refreshData()
        viewModel.getDataPage(limit: 50)
    }
    
    private func setupLoading() {
        loading.startAnimating()
        loading.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        tableView.tableFooterView = loading
        tableView.tableFooterView?.isHidden = false
    }
    
    private func updateInformations() {
        guard let currentPage = viewModel.model?.pagination.currentPage else { return }
        labelInformations.text = "Número de páginas: \(currentPage) Número de ítens: \(viewModel.items.count)"
    }
}
// MARK: Extension
extension PaginationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1): \(items[indexPath.row].title)"
        return cell
    }
}

extension PaginationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalItems = viewModel.items.count
        
        if indexPath.row > totalItems - 3 {
            setupLoading()
            viewModel.getMoreData(limit: 50)
        }
    }
}

extension PaginationViewController: PaginationViewModelDelegate {
    func didSuccess(items: [Item]) {
        self.items = items
        DispatchQueue.main.async {
            self.updateInformations()
            self.tableView.reloadData()
        }
    }
    
    func didFailure(error: String) {
        print(error)
    }
    
    func dismissLoading() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.loading.stopAnimating()
        }
    }
}
