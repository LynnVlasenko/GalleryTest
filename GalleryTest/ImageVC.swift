//
//  ImageVC.swift
//  pageTest
//
//  Created by Oleksandr Smakhtin on 28.02.2023.
//

import UIKit
import CoreImage

//MARK: - ImageIndexDelegate protocol
//протокол, що приймає індекс
protocol ImageIndexDelegate: AnyObject {
    // we use this method to track imageVCs' indexs in PageVC
    func getImageIndex(index: Int)
}

//MARK: - ImageVC
class ImageVC: UIViewController {
//створюємо делегат
    
    //MARK: - Delegates
    weak var imageDelegate: ImageIndexDelegate?
    
    //MARK: - Index
    //знову створюємо лічильник індексів
    // uses when creating instances to provide necessary images
    var index: Int = 0
    
    //MARK: - filter selector
    // uses for change filters
    var filterSelector = 0
    
    //MARK: - Context for filter
    let context = CIContext()
    
    //MARK: - UI Objects
    //передаємо зображення UIImageView - розміщуємо 1 картинку статично
    let catImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "cat1")
        imageView.contentMode = .scaleAspectFill
        //чомусь не працює тінь для картинки. Виходить, що її не видно за вьюшкою в якій вона знаходиться. А зробити тінь для самої вьюшки не виходить - вона не приймає такі параметри.
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageView.layer.shadowColor = UIColor.black.cgColor
        //imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure image depending from setted index
        catImageView.image = UIImage(named: "cat\(index)")
        // add subviews
        addSubviews() //в низу в окремій функції передаємо наш UI об'єкт на в'юшку
        
        //передаємо картинки для catImageView.image за індексок - тобто відповідно який буде індекс - така буде відображатись картинка
//        self.catImageView.image = {
//            //можливо краще зробити через масив, хоча слайдери ж не безкінечні, по факту максимум 10 слайдів - більше вже тупо використовувати, то му може і через світч ок.
//            switch index {
//            case 0:
//                return UIImage(named: "cat1")
//            case 1:
//                return UIImage(named: "cat2")
//            case 2:
//                return UIImage(named: "cat3")
//            default:
//                return UIImage()
//            }
//        }()
    }
    
    //MARK: - Apply filter
    func applyFilter() {
        
        let inputImage = CIImage(image: UIImage(named: "cat\(index)")!)
        
        if filterSelector == 0 {
            let edgesFilter = CIFilter(name:"CIEdges")
            edgesFilter?.setValue(inputImage, forKey: kCIInputImageKey)
            edgesFilter?.setValue(0.9, forKey: kCIInputIntensityKey)
            let edgesCIImage = edgesFilter?.outputImage
            let cgOutputImage = context.createCGImage(edgesCIImage!, from: inputImage!.extent)
            
            catImageView.image = UIImage(cgImage: cgOutputImage!)
            filterSelector += 1
            
        } else {
            
            let filter = CIFilter(name: "CIColorInvert")
            filter!.setValue(inputImage, forKey: kCIInputImageKey)
            let grayscaleCIImage = filter?.outputImage
            let cgOutputImage = context.createCGImage(grayscaleCIImage!, from: inputImage!.extent)
            
            catImageView.image = UIImage(cgImage: cgOutputImage!)
            filterSelector -= 1
        }

    }
    
    //MARK: - Disable filter
    func disableFilter() {
        catImageView.image = UIImage(named: "cat\(index)")
    }
    
    //MARK: - viewWillAppear
    //це якісь стандартні функції
    override func viewWillAppear(_ animated: Bool) { //Якщо true, вид додається до вікна за допомогою анімації.
        super.viewWillAppear(animated)
        // compile when view is configured and going to be shown
        // calls delegate method in PageVC because we conform it when creates instances
        imageDelegate?.getImageIndex(index: index) //передаємо для протоколу повернення індексу картинки сам індекс картинки
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() { //додаємо підвид для відображення картинок
        super.viewDidLayoutSubviews()
        catImageView.frame = view.bounds //фрейм на увесь вью - а саме вью де розміщується картинка описане в MainVC - створений елемент який підпорядкований PageVC - який є UIPageVC - і розмір його фрейма прописаний у констрейнтах - pageVCConstraints
    }
    
    //MARK: - Get Instance
    //функція, що приймає індех і об'єкт і повертає ImageVC - за допомогою цієї функції в PageVC формуємо масив з зображеннями - imagesVCs
    static func getInstance(index: Int, object: ImageIndexDelegate) -> ImageVC { //чому тут static?
        
        let vc = ImageVC() //створюємо константу, що присвоює ImageVC - що є UIViewController
        vc.index = index //передає індекс
        vc.imageDelegate = object //Тут ми підписуєм PageVC під делегат
        
        return vc
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        view.addSubview(catImageView) //додаємо на вьюшку наш елемент catImageView
    }
}
