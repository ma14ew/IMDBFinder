//
//  ViewController.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 09.02.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var presenter: TablePresenterInput = TablePresenter()
    let cellIdentifier = "CellView"
    private lazy var enterText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "Введите в строку поиска название фильма на английском языке"
        return label
    }()
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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 16)
        tableView.rowHeight = 100
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(CellView.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        presenter.setView(view: self)
        setupViews()
        setupConstraints()
    }
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Поиск фильмов"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(enterText)
        tableView.isHidden = true
    }
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        enterText.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalTo(view)
            make.bottom.equalTo(view).inset(0)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
    }
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить данные",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Попробовать еще раз", style: .default, handler: {(action:UIAlertAction!) in
            
        }))
        return alert
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellView", for: indexPath) as? CellView
        let film = presenter.films?[indexPath.row]
        cell?.configureText(film!)
        cell?.configurePhoto(film!)
        return cell ?? UITableViewCell()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        tableView.isHidden = true
        enterText.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        presenter.films? = []
        presenter.searchString = searchBar.text!
        presenter.getFilms()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcPresenter = FilmViewPresenter(film: presenter.films?[indexPath.row])
        let viewController = FilmViewController(presenter: vcPresenter)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.reloadData()
    }
}

extension ViewController: TablePresenterOutput {
    func succes() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
    }
    func failure() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = self.createAlert()
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
}
