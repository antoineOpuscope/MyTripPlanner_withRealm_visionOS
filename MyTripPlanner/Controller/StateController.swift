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
            
            // AOM - debug useful to know the file to open with "Realm Studio" App
            print("Realm is located at:", localRealm!.configuration.fileURL!)

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
    }
    
    // AOM - Dont use  Project instead of ProjectId because otherwise the app crash "Object has been deleted or invalidated." need  to investigate
    // but it works if we do this code in ProjectView directly with project instead of projectId
    func removeProject(projectId: ObjectId) {
        if let projectToRemove = projects.where({$0._id == projectId}).first {
            $projects.remove(projectToRemove)
        }
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
    
    func removeLocation(project: Project, locationId: UInt64) {
        
        guard let thawedProject = project.thaw() else {
            return
        }
        
        if let locationToRemove = thawedProject.locations.first(where: {$0.id == locationId}) {
            if let localRealm {
                do {
                    try localRealm.write {
                        localRealm.delete(locationToRemove)
                        print("done!")
                    }
                } catch {
                    print("Error deleting location: \(error)")
                }
            }
        }
    }
    
    func updateLocation(project: Project, location: Location) {
        
        guard let thawedProject = project.thaw() else {
            return
        }
        
        if let localRealm {
            do {
                try localRealm.write {
                    // Find the index of the location in the locations list
                    if let index = thawedProject.locations.index(of: location) {
                        // Update the location at the found index
                        thawedProject.locations[index] = location
                    }
                }
            }
            catch {
                print("StateController: removeProject error \(error)")
            }
        }
    }
}
