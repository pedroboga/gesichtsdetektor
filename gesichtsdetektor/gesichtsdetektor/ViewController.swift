//
//  ViewController.swift
//  gesichtsdetektor
//
//  Created by Pedro Boga on 11/10/21.
//

import UIKit
import Vision

class ViewController: UIViewController {

    
    var imageTest = UIImageView()
    var countLabel = UILabel()
    var checkButton = UIButton(frame: .zero)
    
    var imageScaledHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        configViews()
        configLayout()
    }

    func configViews() {
        
        guard let image = UIImage(named: "test5")?.fixOrientation() else { return }
        imageTest.image = image
        imageTest.contentMode = .scaleAspectFit
        imageTest.translatesAutoresizingMaskIntoConstraints = false
        imageScaledHeight = view.frame.width / image.size.width * image.size.height
        //imageTest.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        view.addSubview(imageTest)
        
        countLabel.text = "Faces:"
        countLabel.font = UIFont.systemFont(ofSize: 20)
        countLabel.textAlignment = .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countLabel)
        
        checkButton.setTitle("Check", for: .normal)
        checkButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkButton)
    }
    
    func configLayout() {
        NSLayoutConstraint.activate([
            imageTest.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageTest.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageTest.widthAnchor.constraint(equalToConstant: view.frame.width),
            imageTest.heightAnchor.constraint(equalToConstant: imageScaledHeight),
            
            countLabel.topAnchor.constraint(equalTo: imageTest.bottomAnchor, constant: 40),
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 28),
            
            checkButton.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 40),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 100),
            checkButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    @objc func actionButton() {
        imageTest.image?.detectFaces(completion: { result in
            let textCount: String = String(result?.count ?? 0)
            DispatchQueue.main.async {
                self.countLabel.text = "Faces: \(textCount)"
            }
        })
    }
}

extension UIImage {
    func detectFaces(completion: @escaping ([VNFaceObservation]?) -> ()) {
        
        guard let image = self.cgImage else { return completion(nil) }
        let request = VNDetectFaceRectanglesRequest()
        
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(
                cgImage: image
                //orientation: self.cgImageOrientation
            )

            try? handler.perform([request])
            
            guard let observations = request.results else {
                    return completion(nil)
            }

            completion(observations)
        }
    }
    
    func fixOrientation() -> UIImage? {
            UIGraphicsBeginImageContext(self.size)
            self.draw(at: .zero)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        
        var cgImageOrientation: CGImagePropertyOrientation {
            switch self.imageOrientation {
                case .up: return .up
                case .down: return .down
                case .left: return .left
                case .right: return .right
                case .upMirrored: return .upMirrored
                case .downMirrored: return .downMirrored
                case .leftMirrored: return .leftMirrored
                case .rightMirrored: return .rightMirrored
            }
        }
}

