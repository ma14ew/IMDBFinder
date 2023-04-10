//
//  CellViewController.swift
//  IMDBFinder
//
//  Created by Матвей Матюшко on 09.02.2023.
//

import UIKit
import SnapKit

class CellView: UITableViewCell {
    let service = Service()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return view
    }()
    private lazy var headerText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    private lazy var labelText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private lazy var photoImage: UIImageView = {
        let photo = UIImageView()
        photo.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        photo.layer.cornerRadius = 8
        photo.layer.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerText)
        contentView.addSubview(labelText)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(photoImage)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureText(_ viewModel: AboutFilm) {
        photoImage.isHidden = true
        activityIndicator.startAnimating()
        headerText.text = viewModel.title
        labelText.text = viewModel.description
    }
    func configurePhoto(_ viewModel: AboutFilm) {
        let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                service.loadImage(urlString: viewModel.image) { image, error in
                    guard let image = image else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.photoImage.image = image
                    }
                }
                dispatchGroup.leave()
                dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                    guard let self = self else {return}
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.photoImage.isHidden = false
                }
    }
    private func setupConstraints() {
        headerText.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.equalTo(contentView).offset(82)
        }
        labelText.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(82)
            make.right.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView).offset(43)
        }
        photoImage.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(16)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        activityIndicator.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView).offset(16)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
}
