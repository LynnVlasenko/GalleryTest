//
//  PageVC.swift
//  pageTest
//
//  Created by Oleksandr Smakhtin on 28.02.2023.
//

import UIKit

//створюємо протокол що приймає індекс сторінки що буде гортатися
protocol PageControlDelegate: AnyObject {
    func changePage(to index: Int)
}

//створюємо UIPageViewController {
class PageVC: UIPageViewController {

    weak var pageControlDelegate: PageControlDelegate? //створюємо делегат - по типу як я робила в MVP архітектурі
    
    private var imagesVCs = [UIViewController]() //створюємо масив вью контроллерів - але передаємо в нього через функцію getInstance ImageVC
    
    var currentInx = 0 //поточний індекс картинки, яка видображається на слайдері
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        self.delegate = self
        self.dataSource = self
        
        //формуємо масив зображень для слайдера
        imagesVCs = [
            ImageVC.getInstance(index: 0, object: self), //getInstance - функція, що створює об'єкт картинки і повертає imageVC
            ImageVC.getInstance(index: 1, object: self),
            ImageVC.getInstance(index: 2, object: self)
        ]
        
        setViewControllers([imagesVCs[0]], direction: .forward, animated: true) //можливо треба передати тут замість 0 - currentInx? Хоча працює ж і так..
    }
    
    func changeToNext() {
        if currentInx == imagesVCs.count - 1 { //а чому тут так imagesVCs.count - 1, тобто буде 2. В чому сенс? Ааа, це типу якщо ми на останній картинці, то просто виходимо з функції. Щоб кнопка не працювала на останній.
            return
        } else {
            currentInx += 1
            setViewControllers([imagesVCs[currentInx]], direction: .forward, animated: true)//о тут вже ми передаємо поточний індекс
        }
    }
    //тут так само як некст - тільки навпаки. І коли = 0 - то кнопка не активна буде
    func changeToPrev() {
        if currentInx == 0 {
            return
        } else {
            currentInx -= 1
            setViewControllers([imagesVCs[currentInx]], direction: .reverse, animated: true)
        }
    }

}

extension PageVC: ImageIndexDelegate {
    func getImageIndex(index: Int) { //ось тут ми приймаємо індекс зображення, що відображається
        
        pageControlDelegate?.changePage(to: index) //передаємо делегату індекс для протоколу changePage
        print(index)
        currentInx = index //і повертаємо поточний індекс - від нього все і буде працювати
    }
}

//робимо розширення для нашого PageViewController - виконуємо обов'язкові функції, що вказують що буде відбуватися коли готраємо вперед viewControllerAfter або назад viewControllerBefore
extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = imagesVCs.firstIndex(of: viewController)! //не дуже зрозуміла що тут відбувається (тіпу береться перший індекс масиву - а що таке of: viewController?
        
        if currentIndex == 0 {
            return nil
        } else {
            return imagesVCs[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
        let currentIndex = imagesVCs.firstIndex(of: viewController)!
        
        if currentIndex == imagesVCs.count - 1 {
            return nil
        } else {
            return imagesVCs[currentIndex + 1]
        }
    }
}


extension PageVC: UIPageViewControllerDelegate {
    
//    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return imagesVCs.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 0
//    }
    
}
