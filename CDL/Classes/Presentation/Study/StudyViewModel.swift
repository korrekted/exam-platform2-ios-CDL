//
//  StudyViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StudyViewModel {
    private lazy var courseManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var questionManager = QuestionManagerCore()
    private lazy var statsManager = StatsManagerCore()
    
    lazy var sections = makeSections()
    lazy var activeSubscription = makeActiveSubscription()
    lazy var course = makeCourseName()
    lazy var brief = makeBrief()
    
    let selectedCourse = BehaviorRelay<Course?>(value: nil)
    
    private lazy var currentCourse = makeCcurrentCourse().share(replay: 1, scope: .forever)
}

// MARK: Private
private extension StudyViewModel {
    
    func makeCcurrentCourse() -> Observable<Course> {
        let saved = selectedCourse
            .compactMap { $0 }
            .do(onNext: { [weak self] in
                self?.courseManager.select(course: $0)
            })
        
        return courseManager
            .rxGetSelectedCourse()
            .compactMap { $0 }
            .asObservable()
            .concat(saved)
    }
    
    func makeCourseName() -> Driver<Course> {
        return currentCourse
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSections() -> Driver<[StudyCollectionSection]> {
        let modesTitle = makeTitle()
        let modes = makeModes()
        let trophy = makeTrophy()
        let courses = makeCoursesElements()
        
        return Driver
            .combineLatest(courses, modesTitle, modes, trophy) { courses, modesTitle, modes, trophy -> [StudyCollectionSection] in
                var result = [StudyCollectionSection]()
                
                result.append(courses)
                result.append(modesTitle)
                
                if let trophy = trophy {
                    result.append(trophy)
                }
                result.append(modes)
                
                return result
            }
    }
    
    func makeCoursesElements() -> Driver<StudyCollectionSection> {
        Observable.combineLatest(courseManager.retrieveCourses().asObservable(), currentCourse)
            .map { elements, currentCourse in
                let courseElements = elements.map {
                    (course: $0, isSelected: $0.id == currentCourse.id)
                }
                return StudyCollectionSection(elements: [.courses(courseElements)])
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeBrief() -> Driver<SCEBrief> {
        QuestionManagerMediator.shared.rxTestPassed
            .asObservable()
            .startWith(())
            .flatMap { [weak self] _ -> Single<(Course, Brief?)> in
                guard let this = self, let course = self?.courseManager.getSelectedCourse() else {
                    return .never()
                }
                
                return this.statsManager
                    .retrieveBrief(courseId: course.id)
                    .map { (course, $0) }
            }
            .map { stub -> SCEBrief in
                let (course, brief) = stub
                
                var calendar = [SCEBrief.Day]()
                
                for n in 0...6 {
                    let date = Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
                    
                    let briefCalendar = brief?.calendar ?? []
                    let activity = briefCalendar.indices.contains(n) ? briefCalendar[n] : false
    
                    let day = SCEBrief.Day(date: date, activity: activity)
    
                    calendar.append(day)
                }
                
                calendar.reverse()
                
                return SCEBrief(courseName: course.name,
                                      streakDays: brief?.streak ?? 0,
                                      calendar: calendar)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeTitle() -> Driver<StudyCollectionSection> {
        currentCourse
            .map { StudyCollectionSection(elements: [.title($0.name)])}
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeModes() -> Driver<StudyCollectionSection> {
        Driver<StudyCollectionSection>
            .deferred {
                let today = SCEMode(mode: .today,
                                    image: "Study.Mode.Todays",
                                    title: "Study.Mode.TodaysQuestion".localized)
                let todayElement = StudyCollectionElement.mode(today)
                
                let ten = SCEMode(mode: .ten,
                                    image: "Study.Mode.Ten",
                                    title: "Study.Mode.TenQuestions".localized)
                let tenElement = StudyCollectionElement.mode(ten)
                
                let missed = SCEMode(mode: .missed,
                                    image: "Study.Mode.Missed",
                                    title: "Study.Mode.MissedQuestions".localized)
                let missedElement = StudyCollectionElement.mode(missed)
                
                let random = SCEMode(mode: .random,
                                    image: "Study.Mode.Random",
                                    title: "Study.Mode.RandomSet".localized)
                let randomElement = StudyCollectionElement.mode(random)
                
                let section = StudyCollectionSection(elements: [
                    todayElement, tenElement, missedElement, randomElement
                ])
                
                return .just(section)
            }
    }
    
    func makeTrophy() -> Driver<StudyCollectionSection?> {
        activeSubscription
            .compactMap { $0 ? nil : StudyCollectionSection(elements: [.trophy]) }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        let initial = Driver<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Driver
            .merge(initial, updated)
    }
}
