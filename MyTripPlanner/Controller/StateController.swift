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
    
    func addLocation(project: Project, location: Location) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[projectIndex].locations.append(location)
        storageController.save(projects)
    }
    
    func removeLocation(project: Project, location: Location) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[projectIndex].locations.removeAll {$0.id == location.id}
        storageController.save(projects)
    }
    
    func updateLocation(project: Project, location: Location) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[projectIndex].locations.removeAll {$0.id == location.id}
        projects[projectIndex].locations.append(location)
        storageController.save(projects)
    }
}
