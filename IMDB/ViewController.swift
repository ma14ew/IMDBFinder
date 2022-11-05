//
//  ViewController.swift
//  IMDB
//
//  Created by Матвей Матюшко on 05.11.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let service = Service()
    
    
    let cellIdentifier = "CellViewController"
    
    var titleDescriptionImage: [AboutFilmModel] = []
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 100, height: 100))
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.text = "Blade Runner 2049"
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorInset = UIEdgeInsets(top: 0 , left: 82, bottom: 0, right: 16)
        tableView.rowHeight = 100
        return tableView
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.register(CellViewController.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        
        
        setupViews()
        setupConstraints()
        
        
    }
    
    private func setupViews() {
        
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        self.activityIndicator.isHidden = true
        
    }
    
    
    private func setupConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(view)
            make.top.equalTo(view).inset(50)
            
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalTo(view)
            make.bottom.equalTo(view).inset(0)
            
            
        }
        
    }
    
    
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleDescriptionImage.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellViewController
        let viewModel = titleDescriptionImage[indexPath.row]
        cell?.configureText(viewModel)
        cell?.configurePhoto(viewModel)
        return cell ?? UITableViewCell()
        
    }
    
    
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        titleDescriptionImage = []
        self.view.endEditing(true)
        self.tableView.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let searchString = searchBar.text!
        let dispatchGroup = DispatchGroup ()
        dispatchGroup.enter()
        
        
        DispatchQueue.main.async {
            
            self.service.getDataURL(title: searchString) { array, error in
                guard let array = array else {
                    return
                }
                
                for i in 0..<array.count {
                    self.titleDescriptionImage.append(AboutFilmModel(title: array[i]["title"]!, description: array[i]["description"]!, image: array[i]["image"]!))
                    
                    
                }
                dispatchGroup.leave()
                
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {return}
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.isHidden = false
            
            
            
        }
    }
}


