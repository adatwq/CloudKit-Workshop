//
//  ContentView.swift
//  CloudKit Workshop
//
//  Created by Khawlah Khalid on 19/09/2022.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @State var profiles : [Profile] = []

    var body: some View {
        NavigationView{
            List{
                ForEach(profiles) { proile  in
                    HStack(spacing: 2){
                        Image("avatar\(Int.random(in: 1..<7))")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .padding(.vertical)
                            .padding(.horizontal, 2)
                        
                        VStack(alignment: .leading, spacing:6){
                            Text("\(proile.firstName) \(proile.lastName)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("\(proile.major)")
                            Text("\(proile.age) years old")

                        }
                        .padding(6)
                    }
                }
            }
            .listStyle(.plain)
            .onAppear{
                fetchProfiles()
                addLearner()
            }
            .navigationTitle("Learners")
        }
    }
    
        //1
    func fetchProfiles(){
        let predicate = NSPredicate(value: true)
        //2
        //let predicate2 = NSPredicate(format: "firstName == %@", "Sara")
        
        //Record Type depends on what you have named it
        let query = CKQuery(recordType:"Profile", predicate: predicate)
        
        
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { recordId, result in
            DispatchQueue.main.async {
                switch result{
                case .success(let record):
                    let profile = Profile(record: record)
                    self.profiles.append(profile)
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
//3
func addLearner(){
    let record = CKRecord(recordType: "Profile")
    record["firstName"] = "Reema"
    record["lastName"] = "Ahmed"
    record["major"] = "Art"
    record["age"] = 23
    CKContainer.default().publicCloudDatabase.save(record) { record, error in
        guard  error  == nil else{
            print(error?.localizedDescription)
            return
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Profile : Identifiable{
    let id : CKRecord.ID
    let firstName : String
    let lastName : String
    let major : String
    let age : Int
    
    init(record:CKRecord){
        self.id        = record.recordID
        self.firstName = record["firstName"] as? String ?? "N/A"
        self.lastName  = record["lastName"] as? String ?? "N/A"
        self.major     = record["major"] as? String ?? "N/A"
        self.age       = record["age"] as? Int ?? 18
    }
    
}
