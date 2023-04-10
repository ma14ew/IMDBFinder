//
//  AboutFilmViewController.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 09.02.2023.
//

import Foundation
import UIKit
import SnapKit

class FilmViewController: UIViewController {
    private let service = Service()
    private var presenter: FilmViewPresenterInput
    init(presenter: FilmViewPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   private lazy var photoImage: UIImageView = {
        let image = UIImageView()
        image.sizeToFit()
        return image
    }()
    private lazy var titleText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    private lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.setView(view: self)
    }
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(photoImage)
        view.addSubview(titleText)
        view.addSubview(descriptionText)
    }
    private func setupConstraints() {
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(100)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        titleText.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).inset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(titleText.snp.bottom).offset(5)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.height.equalTo(150)
        }
    }
}

extension FilmViewController: FilmViewPresenterOutput {
    func configure() {
        titleText.text = presenter.title
        descriptionText.text = presenter.description
        service.loadImage(urlString: presenter.image) { [weak self] image, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let image = image else {
                    return
                }
                self.photoImage.image = image
            }
        }
    }
}
