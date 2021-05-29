//
//  ViewController.swift
//  cursova
//
//  Created by Bohdan Andriychuk on 29.05.2021.
//

import UIKit
import Foundation

var ourMoney: Int = 20000
var arrDependsProjects: [DependerProjects] = []
var simpleProjects: [Project] = []
var takesProjects: [Project] = []

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrDependsProjects.append(DependerProjects(dependProjects: [Project(projectName: "project 1", profit: 10000, spends: 5000), Project(projectName: "project 2", profit: 15000, spends: 4000)], mainProjects: [Project(projectName: "projects 3", profit: 12000, spends: 3000), Project(projectName: "Project 4", profit: 10000, spends: 5000)]))
        arrDependsProjects.append(DependerProjects(dependProjects: [Project(projectName: "project 5", profit: 10000, spends: 5000), Project(projectName: "project 6", profit: 15000, spends: 4000)], mainProjects: [Project(projectName: "projects 7", profit: 12000, spends: 3000), Project(projectName: "Project 8", profit: 10000, spends: 5000)]))
        arrDependsProjects.append(DependerProjects(dependProjects: [Project(projectName: "project 9", profit: 10000, spends: 5000), Project(projectName: "project 10", profit: 15000, spends: 4000)], mainProjects: [Project(projectName: "projects 11", profit: 12000, spends: 3000), Project(projectName: "Project 12", profit: 10000, spends: 5000)]))

        for projects in arrDependsProjects.sorted(by: { $0.maxProfit > $1.maxProfit }) {
            if takeCurrentSpends(projects: takesProjects) + projects.maxSpends <= ourMoney {
                guard let ourProjects = projects.maxCombinationProjects  else { return }
                guard let dependP = ourProjects.profectDependProject  else { return }
                guard let mainP = ourProjects.mainProject  else { return }
                
                takesProjects.append(dependP)
                takesProjects.append(mainP)
            }
        }

        for i in takeAllProjects(projects: arrDependsProjects, simpleProjects: simpleProjects).sorted(by: { $0.profit > $1.profit }) {
            if !takesProjects.contains(where: { (project) -> Bool in
                project.projectName == i.projectName
            }) {
                 if i.getAccessToProject() && i.spends + takeCurrentSpends(projects: takesProjects) <= ourMoney {
                     takesProjects.append(i)
                }
            }
        }
        for i in takesProjects {
            print(i.projectName)
        }
        print(takeCurrentSpends(projects: takesProjects))
        print(takeCurrentProfit(projects: takesProjects))
    }
    
    
}


func takeCurrentSpends(projects: [Project]) -> Int {
    var sum = 0
    for i in projects {
        sum = sum + i.spends
    }
    return sum
}

func takeCurrentProfit(projects: [Project]) -> Int {
    var sum = 0
    for i in projects {
        sum = sum + i.profit
    }
    return sum
}
func takeAllProjects(projects: [DependerProjects], simpleProjects: [Project] = []) -> [Project] {
    var allProjects: [Project] = []
    for i in projects {
        allProjects.append(contentsOf: i.dependProjects)
        allProjects.append(contentsOf: i.mainProjects)
    }
    allProjects.append(contentsOf: simpleProjects)
    return allProjects
}

class DependerProjects {
    var dependProjects: [Project]
    var mainProjects: [Project]
    var maxProfit: Int = 0
    var maxSpends: Int = 0
    var maxCombinationProjects: CombinationOfProjects?

    init(dependProjects: [Project], mainProjects: [Project]) {
        self.dependProjects = dependProjects
        self.mainProjects = mainProjects
        self.maxCombinationProjects = getBestCombination()
        for project in dependProjects {
            project.mainProjects = mainProjects
        }
    }

    func getBestCombination() -> CombinationOfProjects?  {
        let max = CombinationOfProjects()
        
        for dependProject in dependProjects {
            if dependProject.spends <= ourMoney {
                 for mainProject in mainProjects {
                    if mainProject.spends <= ourMoney {
                        if max.getSumProfit() < mainProject.profit + dependProject.profit {
                            if mainProject.spends + dependProject.spends <= ourMoney {
                                max.profectDependProject = dependProject
                                max.mainProject = mainProject
                            }
                        }
                    }
                }
            }
        }
        self.maxSpends = (max.mainProject?.spends ?? 0) + (max.profectDependProject?.spends ?? 0)
        self.maxProfit = (max.mainProject?.profit ?? 0) + (max.profectDependProject?.profit ?? 0)
        return max
    }

}

class CombinationOfProjects {
    var profectDependProject: Project?
    var mainProject: Project?
    
    
    func getSumProfit() -> Int {
        return (self.profectDependProject?.profit ?? 0) + (self.mainProject?.profit ?? 0)
    }
}

class Project {
    let projectName: String
    let profit: Int
    let spends: Int
    var mainProjects: [Project]?
    init(projectName: String, profit: Int, spends: Int) {
        self.projectName = projectName
        self.profit = profit
        self.spends = spends
    }

    func getAccessToProject() -> Bool {
        guard let mainProjects = mainProjects else { return true }
        var result = false
        for i in mainProjects {
            if takesProjects.contains(where: { (project) -> Bool in
                project.projectName == i.projectName
            }) {
                result = true
            }
        }
        return result
    }
}
