//
//  StateController.swift
//  Banking
//
//  Created by Antoine Omnès
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation
import CoreLocation

class StateController: ObservableObject {
	@Published var projects: [Project]
	
    // TODO: create a list location in StateController and Project will contains only locations Ids
    
	private let storageController = StorageController()
	
	init() {
		self.projects = storageController.fetchProject()
	}
    
    func mergeSelectedProjects(selectedProject: Set<UUID>) {
        let selectedProjects: [Project] = self.projects.filter {selectedProject.contains($0.id)}
        
        // Create a set to store unique coordinates
        var uniqueCoordinates = Set<CLLocationCoordinate2D>()

        // Use flatMap to extract all Location objects from the projects
        let allUniqueLocations = selectedProjects.flatMap { project in
            project.locations.filter {
                // Insert the coordinate into the set, and only keep the location if it's unique
                uniqueCoordinates.insert($0.coordinate).inserted
            }
        }
        let allUniqueLocationDeepCopy = allUniqueLocations.map {Location(copying: $0)}
        
        let project = Project(name: selectedProjects.map {$0.name}.joined(separator: "-"), locations: allUniqueLocationDeepCopy)
        
        self.addProject(project: project)
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
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }

        projects[projectIndex] = project
        self.objectWillChange.send()
        storageController.save(projects)
    }
    
    func addLocation(project: Project, location: Location) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[projectIndex].locations.append(location)
        self.objectWillChange.send()
        storageController.save(projects)
    }
    
    func removeLocation(project: Project, location: Location) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[projectIndex].locations.removeAll {$0.id == location.id}
        self.objectWillChange.send()
        storageController.save(projects)
    }
    
    func updateLocation(project: Project, location: Location) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == project.id }) else { return }
        guard let locationIndex = projects[projectIndex].locations.firstIndex(where: { $0.id == location.id }) else { return }
        
        // Maybe it is overkill but it is a first solution
        projects[projectIndex].locations[locationIndex] = location
        self.objectWillChange.send()
        storageController.save(projects)
    }
}
