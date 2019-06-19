William Hickman
Project Milestone 4

NOTE: Same README.md as for Milestone 3

API's Used and How They are Shown:

1. HealthKit:                 Location - SleepAnalysisViewController.swift
      
      - Gets the sleep data of the user from HealthStore
      - Will be used to identify outliers and anticipate harder days
      - Asks for read and write permissions from the user (only read later on)
      - Reads from pre-existing data, so if none exists, writer method is provided (commented call in viewdidload)
      - Currently set to print read data (InBed and Asleep times) to console

2. SwiftChart:                Location - SleepAnalysisViewController.swift

      - Will display collected sleep data on a chart
      - Line chart is in use to display data
      - Works as a custom UIView
      - Currently populated with placeholder data
      - Chart is visible when app launches

3. Firebase (RT Database):    Location - EntertainmentViewController.swift

      - Used to store Media information remotely
      - Nudge will and currently only reads in data
      - User should not add videos, only enjoy current ones
      - Videos added by myself through another app (not included)
      - Media in TableView comes from Firebase
      - When data is obtained, quick message printed to console

4. CodableFirebase:           Location - EntertainmentViewController.swift

      - Used to be able to read Firebase data through Codable
      - Currently used to my desired capability in getting Firebase data

5. WebKit:                    Location - MediaViewController.swift

      - Acts as the media displayer
      - Takes a url for a YouTube video and plays it in the app (takes a second)
      - Visible when cell in the Entertainment tab is selected (new page)

6. UIKit:                     Location - most files
      
      - Used for UI elements, probably does not need to be in this list

NOTE: In the second milestone, I said I would use FrostKit and MediaPlayer.  
However, while I was implementing the third milestone, I found that WebKit 
was more preferable.  Hence, I swapped FrostKit and MediaPlayer out for WebKit. 

Please run "Nudge.xcworkspace", rather than "Nudge.xcodeproj"

Upon opening, sometimes xcode says that there are errors.  However, when told
to run on the simulator, the errors go away
