//
//  ImageVC.swift
//  pageTest
//
//  Created by Oleksandr Smakhtin on 28.02.2023.
//

import UIKit
import CoreImage

//протокол, що приймає індекс
protocol ImageIndexDelegate: AnyObject {
    func getImageIndex(index: Int)
}

class ImageVC: UIViewController {
//створюємо делегат
    weak var imageDelegate: ImageIndexDelegate?
    //знову створюємо лічильник індексів
    var index: Int = 0
    //передаємо зображення UIImageView - розміщуємо 1 картинку статично
    let catImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cat1")
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
        
        //передаємо картинки для catImageView.image за індексок - тобто відповідно який буде індекс - така буде відображатись картинка
        self.catImageView.image = {
            //можливо краще зробити через масив, хоча слайдери ж не безкінечні, по факту максимум 10 слайдів - більше вже тупо використовувати, то му може і через світч ок.
            switch index {
            case 0:
                return UIImage(named: "cat1")
            case 1:
                return UIImage(named: "cat2")
            case 2:
                return UIImage(named: "cat3")
            default:
                return UIImage()
            }
        }()
        addSubviews()//в низу в окремій функції передаємо наш UI об'єкт на в'юшку
    }
    
    //це якісь стандартні функції
    override func viewWillAppear(_ animated: Bool) { //Якщо true, вид додається до вікна за допомогою анімації.
        super.viewWillAppear(animated)
        imageDelegate?.getImageIndex(index: index) //передаємо для протоколу повернення індексу картинки сам індекс картинки
    }
    
    override func viewDidLayoutSubviews() { //додаємо підвид для відображення картинок
        super.viewDidLayoutSubviews()
        catImageView.frame = view.bounds //фрейм на увесь вью - а саме вью де розміщується картинка описане в MainVC - створений елемент який підпорядкований PageVC - який є UIPageVC - і розмір його фрейма прописаний у констрейнтах - pageVCConstraints
    }
    
    //функція, що приймає індех і об'єкт і повертає ImageVC - за допомогою цієї функції в PageVC формуємо масив з зображеннями - imagesVCs
    static func getInstance(index: Int, object: ImageIndexDelegate) -> ImageVC { //чому тут static?
        
        let vc = ImageVC() //створюємо константу, що присвоює ImageVC - що є UIViewController
        vc.index = index //передає індекс
        vc.imageDelegate = object //і для чогось кажемо що наш делегат є обєектом, який приймає ця функція
        
        return vc
    }
    
    private func addSubviews() {
        view.addSubview(catImageView) //додаємо на вьюшку наш елемент catImageView
    }
}
