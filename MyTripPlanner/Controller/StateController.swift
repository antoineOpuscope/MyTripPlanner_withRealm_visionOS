//
//  StateController.swift
//  Banking
//
//  Created by Antoine Omnès
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation

class StateController: ObservableObject {
	@Published var projects: [Project]
	
	private let storageController = StorageController()
	
	init() {
		self.projects = storageController.fetchProject()
	}
    
    func addProject(project: Project) {
        projects.append(project)
        storageController.save(projects)
    }
    
    func removeProject(project: Project) {
        projects.removeAll {$0.id == project.id}
        storageController.save(projects)
    }
    
    func updateProject(project: Project) {
        projects.removeAll {$0.id == project.id}
        projects.append(project)
        storageController.save(projects)
    }
    
    func addLocation(project: Project) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        let location = Location()
        projects[projectIndex].locations.append(location)
        storageController.save(projects)
    }
}
