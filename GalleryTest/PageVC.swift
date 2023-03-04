//
//  PageVC.swift
//  pageTest
//
//  Created by Oleksandr Smakhtin on 28.02.2023.
//

import UIKit
import CoreImage

//MARK: - PageControllDelegate
//створюємо протокол що приймає індекс сторінки що буде гортатися
protocol PageControlDelegate: AnyObject {
    // use this method in MainVC to track of the index of vc that is shown and change page control
    func changePage(to index: Int)
}

//MARK: - UIPageViewController
//створюємо UIPageViewController {
class PageVC: UIPageViewController {
    // delegate
    weak var pageControlDelegate: PageControlDelegate? //створюємо делегат - по типу як я робила в MVP архітектурі
    // array for images VCs
    private var imagesVCs = [ImageVC]()
    //private var imagesVCs = [UIViewController]() //створюємо масив вью контроллерів - але передаємо в нього через функцію getInstance ImageVC
    // holds the current index of vc that is shown
    var currentInx = 0 //поточний індекс картинки, яка видображається на слайдері

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // change bg
        view.backgroundColor = .systemBackground
    
        // set UIPageViewControllerDataSource
        self.dataSource = self
        
        // get instances
        //формуємо масив зображень для слайдера
        imagesVCs = [
            ImageVC.getInstance(index: 0, object: self), //getInstance - функція, що створює об'єкт картинки і повертає imageVC
            ImageVC.getInstance(index: 1, object: self),
            ImageVC.getInstance(index: 2, object: self)
        ]
        // set first vc
        setViewControllers([imagesVCs[0]], direction: .forward, animated: true) //можливо треба передати тут замість 0 - currentInx? Хоча працює ж і так..
    }
    
    //MARK: - Change to next
    func changeToNext() {
        // use this method to change vc by tapping a btn
        if currentInx == imagesVCs.count - 1 { //а чому тут так imagesVCs.count - 1, тобто буде 2. В чому сенс? Ааа, це типу якщо ми на останній картинці, то просто виходимо з функції. Щоб кнопка не працювала на останній.
            return
        } else {
            currentInx += 1
            setViewControllers([imagesVCs[currentInx]], direction: .forward, animated: true)//о тут вже ми передаємо поточний індекс
        }
    }
    
    //MARK: - Change to previous
    //тут так само як некст - тільки навпаки. І коли = 0 - то кнопка не активна буде
    func changeToPrev() {
        // use this method to change vc by tapping a btn
        if currentInx == 0 {
            return
        } else {
            currentInx -= 1
            setViewControllers([imagesVCs[currentInx]], direction: .reverse, animated: true)
        }
    }
    
    //MARK: - changeFilter
    func changeFilter() {
        imagesVCs[currentInx].applyFilter() //передаємо функцію для фільтра, що реалізована в ImageVC
    }

    //MARK: - Disable filter
    func disableFilter() {
        imagesVCs[currentInx].disableFilter() //передаємо функцію для фільтра, що реалізована в ImageVC
    }
}

//MARK: - ImageIndexDelegate
extension PageVC: ImageIndexDelegate {
    // calls when each imageVC is shown
    func getImageIndex(index: Int) { //ось тут ми приймаємо індекс зображення, що відображається
        // use pageControlDelegate method to send current index to MainVC
        pageControlDelegate?.changePage(to: index) //передаємо делегату індекс для протоколу changePage
        print(index)
        // change currentInx value
        currentInx = index //і повертаємо поточний індекс - від нього все і буде працювати
    }
}

//MARK: - UIPageViewConstrollerDataSource
//робимо розширення для нашого PageViewController - виконуємо обов'язкові функції, що вказують що буде відбуватися коли готраємо вперед viewControllerAfter або назад viewControllerBefore
// defines which of VCs is before the actual VC
extension PageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = imagesVCs.firstIndex(of: viewController as! ImageVC)! //не дуже зрозуміла що тут відбувається (тіпу береться перший індекс масиву - а що таке of: viewController?
        
        if currentIndex == 0 {
            return nil
        } else {
            return imagesVCs[currentIndex - 1]
        }
    }
    
    // defines which of VCs is after the actual VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
        let currentIndex = imagesVCs.firstIndex(of: viewController as! ImageVC)!
        
        if currentIndex == imagesVCs.count - 1 {
            return nil
        } else {
            return imagesVCs[currentIndex + 1]
        }
    }
}
