//
//  JobApplications+CoreDataProperties.swift
//  
//
//  Created by Technology on 05/09/22.
//
//

import Foundation
import CoreData


extension JobApplications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobApplications> {
        return NSFetchRequest<JobApplications>(entityName: "JobApplications")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var jobId: String?
    @NSManaged public var resumeFilePath: String?
    @NSManaged public var linkedInURL: URL?
    @NSManaged public var githubURL: URL?
    @NSManaged public var mobileNumber: Int64
    @NSManaged public var otherURL: URL?
    @NSManaged public var email: String?
    @NSManaged public var status: Int16
    @NSManaged public var resumeScore: Int16
    @NSManaged public var id: String?
    @NSManaged public var userId: String?
    @NSManaged public var skills: [String]?
    @NSManaged public var createdAt: Date?
    @NSManaged public var fileUniquifier: String?
    @NSManaged public var fileId: String?
    @NSManaged public var fileAccountId: String?
    @NSManaged public var systemStatus: Int16

}
