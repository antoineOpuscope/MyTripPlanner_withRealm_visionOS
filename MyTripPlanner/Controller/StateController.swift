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
    
    func mergeSelectedProjects(selectedProject: Set<UInt64>) {
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
        self.objectWillChange.send()
    }
    
    // AOM - Dont use  Project instead of ProjectId because otherwise the app crash "Object has been deleted or invalidated." need  to investigate
    // but it works if we do this code in ProjectView directly with project instead of projectId
    func removeProject(projectId: ObjectId) {
        if let projectToRemove = projects.where {$0._id == projectId}.first {
            $projects.remove(projectToRemove)
        }
        self.objectWillChange.send()
    }
    
    func updateProject(project: Project) {

        if let localRealm {
            do {
                try localRealm.write {
                    localRealm.create(Project.self, value: project, update: .modified)
                }
            }
            catch {
                print("StateController: removeProject error \(error)")
            }
        }
        self.objectWillChange.send()
    }
    
    func addLocation(project: Project, location: Location) {
        
        guard let thawedProject = project.thaw() else {
            return
        }
        
        if let localRealm {
            do {
                try localRealm.write {
                    thawedProject.locations.append(location)
                }
            }
            catch {
                print("StateController: removeProject error \(error)")
            }
        }
    }
    
    func removeLocationV2(_ location: Location) {
            guard let thawedLocation = location.thaw() else {
                return
            }

            if thawedLocation.isInvalidated == false { //ensure it's a valid item
                let thawedRealm = thawedLocation.realm! //get the realm it belongs to
                do {
                    try thawedRealm.write {
                        thawedRealm.delete(thawedLocation)
                    }
                } catch {
                    print("Error deleting user: \(error)")
                }
            }
        }
    
    func removeLocation(project: Project, location: Location) {
        if let localRealm {
            do {
                try localRealm.write {
                    if let index = project.locations.index(of: location) {
                        project.locations.remove(at: index)
                    }
                }
            }
            catch {
                print("StateController: removeProject error \(error)")
            }
        }
        self.objectWillChange.send()
    }
    
    func updateLocation(project: Project, location: Location) {
        if let localRealm {
            do {
                try localRealm.write {
                    // Find the index of the location in the locations list
                    if let index = project.locations.index(of: location) {
                        // Update the location at the found index
                        project.locations[index] = location
                    }
                }
            }
            catch {
                print("StateController: removeProject error \(error)")
            }
        }
    }
}
