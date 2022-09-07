# AlderedahAssignment

## Project Description

The project is all about creating career page for company. 

**_What happens on career page?_**

User visits on a company website, look for career option and on career, there is mechanism by which user sends his information to company by 

1. Uploading resume
2. Filling his basic information
3. Telling about the skills
4. Quick links that describes candidate
5. Contact information.

**_What user can do?_**
The app allows user to do all this functionality but for that user has to **LOGIN** into the app.

For LOGIN he has to **REGISTER** into app

Then **APPLY JOB**
See his application in **MY APPLICATION** section

This app is not only works for user but also helps company admin/hr to see the received applications. but for that, admin has to **LOGIN** in same way as User

**_What admin can do?_**
see all applications in **APPLICATIONS** tab
filter app using search on the same page

quick look on **DASHBOARD** tab to see number of applications that are received and out of which how many are Rejected, Selected and How many are best resumes.
Click on that particular tab will show those profiles only

**_What system does?_**
Every profie or application that user put is given score and system applies his own algorithm to sort the applications

## How to Install and Run the Project

### Technology stack
    - uses _swift_ language
    - developed for _ios_ users
    - uses minimum _15.5 version_ of ios
    - _native_ ios development
    
### Architecture used
    - MVC (Modal View controlller)

### Design patterns used
    - Singleton
    - Broadcasters
    - Services
    - Delegation

    
### installation
    - Need **xcode**
    - open **terminal**
    - go inside project folder named (AlderadahCareerAssignmentSumit)
    - run command **pod install** . in case pods are not available in your system. install if from guide availablle at https://cocoapods.org/
    - A file named **AlderadahCareerAssignmentSumit.xcworkspace** will be genrated. Open that file and you will have all the project fies opened in Xcode
    
### Test cases available - 
    - Unit test cases
    
## Concepts covered
    - core data
    - calling REST apis
    - Pagination
    - Login/register
    - Unit Test
    - Singleton
    - retain cycle
    - Dispatch queues
    - Notificationcenter
    - Structs 
    - classes
    - enums
    - Protocols and Delegates
    - Extensions
    - Inheritance
    - Encapsulation
    - Utilities

## Assessment Overview: The assessment will test your frontend skills in building an application form for hiring [Career Page] with the following features : 
### Part 1: 
    - _Ability to see all applications with the ability to change the status for applications between [ Created, Completed, Accepted, Rejected] (Admin Panel )_
        Done when login throug admin user
        
    - Ability to edit/delete applications ( Admin Panel ) Ability to upload files [ Such as CV ] ( Career Page )
        Delete application ability is there. User can upload files
        
    - Ability to add skills from a pre-defined list of skills and the ability for the candidate to choose others and specify. ( Career Page )
        skills can be added while applying for job
        
    - Ability to apply filters. ( Career Page )
        search filter in applications listing
        filter based upon status in dashboard page (admin)
        
    - Pagination is a plus. (Admin Panel )
        working in my applications listing

    - Sign in / Signup is a plus
        working

### Part 2:  
    _We want to create a resume evaluation that is based on a backend service return. The Backend provides us with JSON for every resume submitted that has an overall score, first name, last name, resume link, and LinkedIn link. The main task here is to build a simple dashboard to display the best resume as we submit them through the app and automatically change the application status (accepted, rejected) based on the overall score._  
        - Dashboard is created for admin
        - in Application.swift class, there is function to allot score to profile
 
### Assessment Objectives: 
    _Integration with REST APIs. [ use fake API to provide data needed and integrate with it ]._
    - fake apis used from https://mockapi.io/
    - upload file is working for https://upload.io/
    
    _Ability to produce a good-looking website by taking into consideration UI/UX guidelines and practices. [ It has the highest score, Design needs to be professional ] Measurement of the Learning Curve and the ability to do tasks in a short time._
        ui/ux is kept as per apple guidelines
 
### Assessment Guidelines: 
    _We want to build a mobile app, please use your best judgment when it comes to language and platform (Swift or Kotling is very desirable)._
    - Swift language is used
     
    _Make sure there is unit test coverage._
    - Unit tests are written
    
    _Make sure to mock backend returns based on the problem description._
    - mock apis are used
    
    _Make sure to submit the solution to Github._
    - Github link (https://github.com/sumitsynergyworks/AlderedahAssignment)
    
    _MAKE SURE THE ASSESSMENT IS DONE USING PURE CODE NOT ANY GENERATOR_
    - purely programming is done in 5 days.
    
    

