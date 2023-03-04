//
//  MainVC.swift
//  pageTest
//
//  Created by Oleksandr Smakhtin on 28.02.2023.
//

import UIKit

class MainVC: UIViewController {

    private var pageIndex = 0 //створюємо лічильник для сторінок, які будемо гортати у слайдері - не дуже розумію для чого він - бо він ніде не використовується і вже маємо currentInx - в PageVC
    
    //Створюємо pageControl - крапки -індикатори, що показують на якій ми сторінці
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //Заголовок застосунку
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Cats Gallery".uppercased()
        label.textColor = .label
        label.font = UIFont(name: "Roboto-Bold", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //кнопка для накладення ч/б ефекту
    private let filterBtn: UIButton = {
        let btn = UIButton(type: .system) //що означає type: .system для кнопки?
        btn.setTitle("Black & White".uppercased(), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        btn.backgroundColor = .label//що значить колір .label?
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //кнопка, що переключає на попередню фото
    private let prevBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Prev".uppercased(), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        btn.backgroundColor = .label
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //кнопка, що переключає на наступне фото
    private let nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next".uppercased(), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        btn.backgroundColor = .label
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //створюємо вью контроллер для сторінок і передаємо йому тип PageVC, який є UIPageViewController - вью контроллер в якому будуть розміщені і гортатимуться фото
    private let pageVC: PageVC = {
        let vc = PageVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        vc.layer.shadowRadius = 5
//        vc.layer.shadowOpacity = 0.5
//        vc.layer.shadowOffset = CGSize(width: 0, height: 5)
//        vc.layer.shadowColor = UIColor.black.cgColor
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    //передаю вью контроллер для доступу до нього для зміни кольору зображення
//    private let imageVC: ImageVC = {
//        let vc = ImageVC()
//        return vc
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        applyConstraints()
        addTargets()
        pageVC.pageControlDelegate = self
    }
    
    //функція, що додає дії для кнопок
    private func addTargets() {
        // next action
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        // prev action
        prevBtn.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        // apply filter action
        filterBtn.addTarget(self, action: #selector(changeFilterAction), for: .touchUpInside)
        // create tap gesture recognizer to detect double taps
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(disableFilterAction))
        // set required taps
        doubleTap.numberOfTapsRequired = 2
        // add gesture to filter btn
        filterBtn.addGestureRecognizer(doubleTap)
    }
    
    //функція що запускає функцію changeToNext() для кнопки next - прописана у pageVC
    @objc private func nextAction() {
        pageVC.changeToNext() //доступаємось за рахунок того, що pageVC підпорядковується PageVC, який є UIPageViewController
        
    }
    
    //функція що запускає функцію changeToPrev() для кнопки next - прописана у pageVC
    @objc private func prevAction() {
        pageVC.changeToPrev() //доступаємось за рахунок того, що pageVC підпорядковується PageVC, який є UIPageViewController
    }
    
    @objc private func changeFilterAction() {
        pageVC.changeFilter()
    }
    @objc private func disableFilterAction() {
        pageVC.disableFilter()
    }
    
    private func addSubviews() {
        addChild(pageVC) //що таке addChild - додаю як дочерній елемент поверх основного
        view.addSubview(pageVC.view)//це типу ми доступаємося до view іншого вью контроллера. Круто
        view.addSubview(titleLbl)
        view.addSubview(prevBtn)
        view.addSubview(nextBtn)
        view.addSubview(filterBtn)
        view.addSubview(pageControl)
    }
    
    private func applyConstraints() {
        
        let titleLblConstraints = [
            titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let pageVCConstraints = [
            pageVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageVC.view.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 50),
            pageVC.view.heightAnchor.constraint(equalToConstant: 380),
            pageVC.view.widthAnchor.constraint(equalToConstant: 380)
        ]
        
        let prevBtnConstraints = [
            prevBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            prevBtn.topAnchor.constraint(equalTo: pageVC.view.bottomAnchor, constant: 60),
            prevBtn.heightAnchor.constraint(equalToConstant: 60),
            prevBtn.widthAnchor.constraint(equalToConstant: 155)
        ]
        
        let nextBtnConstraints = [
            nextBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            nextBtn.topAnchor.constraint(equalTo: pageVC.view.bottomAnchor, constant: 60),
            nextBtn.heightAnchor.constraint(equalToConstant: 60),
            nextBtn.widthAnchor.constraint(equalToConstant: 155)
        ]
        
        let filterBtnConstraints = [
            filterBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            filterBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            filterBtn.heightAnchor.constraint(equalToConstant: 60),
            filterBtn.topAnchor.constraint(equalTo: nextBtn.bottomAnchor, constant: 40)
        ]
        
        let pageControlConstraints = [
            pageControl.topAnchor.constraint(equalTo: pageVC.view.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(pageVCConstraints)
        NSLayoutConstraint.activate(prevBtnConstraints)
        NSLayoutConstraint.activate(nextBtnConstraints)
        NSLayoutConstraint.activate(filterBtnConstraints)
        NSLayoutConstraint.activate(pageControlConstraints)
    }

}

//виконуємо розширення основного вью і підпорядковуємо його протоколу з PageVC - PageControlDelegate
extension MainVC: PageControlDelegate {
    func changePage(to index: Int) { //передаємо
        pageControl.currentPage = index //currentPage - це вбудований метод для pageControl
        pageIndex = index //передаємо індекс для pageIndex
    }
    
}
