//
//  StateController.swift
//  Banking
//
//  Created by Antoine Omnès
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

@MainActor
class StateController: ObservableObject {
    private(set) var localRealm: Realm?
    @ObservedResults(Project.self) var projects
	
	init() {
        self.openRealm()
	}
    
    func openRealm() {
        do {
            // Setting the schema version
            let config = Realm.Configuration(schemaVersion: 1)

            // Letting Realm know we want the defaultConfiguration to be the config variable
            Realm.Configuration.defaultConfiguration = config

            // Trying to open a Realm and saving it into the localRealm variable
            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func mergeSelectedProjects(selectedProject: Set<UUID>) {
        /*
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
         */
    }
    
    func addProject(project: Project) {
        $projects.append(project)
    }
    
    func removeProject(project: Project) {
        if let localRealm {
            // TOODO: AOM - Remove this `!`
            try! localRealm.write {
                localRealm.delete(project)
            }
        }
    }
    
    func updateProject(project: Project) {
        if let localRealm {
            try! localRealm.write {
                localRealm.add(project, update: .modified)
            }
        }
    }
    
    func addLocation(project: Project, location: Location) {
        if let localRealm {
            // TOODO: AOM - Remove this `!`
            try! localRealm.write {
                project.locations.append(location)
            }
        }
    }
    
    func removeLocation(project: Project, location: Location) {
        if let localRealm {
            // TOODO: AOM - Remove this `!`
            try! localRealm.write {
                if let index = project.locations.index(of: location) {
                    project.locations.remove(at: index)
                }
            }
        }
        self.objectWillChange.send()
    }
    
    func updateLocation(project: Project, location: Location) {
        if let localRealm {
            // TOODO: AOM - Remove this `!`
            try! localRealm.write {
                // Find the index of the location in the locations list
                if let index = project.locations.index(of: location) {
                    // Update the location at the found index
                    project.locations[index] = location
                }
            }
        }
    }
}
