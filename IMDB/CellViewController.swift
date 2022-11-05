//
//  CellViewController.swift
//  IMDB
//
//  Created by Матвей Матюшко on 05.11.2022.
//

import UIKit
import SnapKit
import Alamofire

class CellViewController: UITableViewCell{
    
    let service = Service()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return view
    }()
    
    private lazy var headerText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    } ()
    
    private lazy var labelText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    } ()
    
    
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
    
    
    func configureText(_ viewModel: AboutFilmModel) {
        photoImage.isHidden = true
        activityIndicator.startAnimating()
        
        headerText.text = viewModel.title
        labelText.text = viewModel.description
    }
    
    func configurePhoto(_ viewModel: AboutFilmModel){
        DispatchQueue.main.async {
            AF.request( viewModel.image, method: .get).response{ response in
                
                switch response.result {
                    
                case .success(let responseData):
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.photoImage.isHidden = false
                    self.photoImage.image = UIImage(data: responseData!, scale:1)
                    
                case .failure(let error):
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.photoImage.isHidden = false
                    self.photoImage.image = UIImage()
                    print("error--->",error)
                }
            }
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


