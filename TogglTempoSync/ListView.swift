//
//  ListView.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 02/02/2022.
//

import SwiftUI

struct ListView: View {
    let network = Network()
    @ObservedObject var viewModel: TimeEntriesModel = TimeEntriesModel()
    @State private var date = Date()
    
    func reload() async{
        await viewModel.reload(date: date)
    }
    
    func sync() async {
        await viewModel.sync(date: date)
    }

    var body: some View {
        VStack{
            HStack{
                Text("Time Entries")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    Task { await reload() }
                }) {
                    Text("Refresh")
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    Task{ await sync() }
                }) {
                    Text("Sync with Tempo")
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                HStack{
                    Text("Entries Date")
                        .bold()
                }
            }
            .padding(.horizontal)
            if(viewModel.loading == true){
                ProgressView()
            }else if(viewModel.error != nil){
                Text("Error fetching time entries")
            }else if(viewModel.timeEntries.count == 0){
                Text("No time entries for today")
            }else{
                List {
                    ForEach(viewModel.timeEntries) { item in
                        TimeEntryView(description: item.description, start: item.start, stop: item.stop, issueKey: item.issueKey, duration: item.durationStr, sync: item.sync)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.reload(date: date)
                }
            }
            Spacer()
        }
        .onChange(of: date) { date in
            Task {
                await viewModel.reload(date: date)
            }
        }
        .onAppear{
            Task {
                await viewModel.reload(date: date)
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListView()
        }
    }
}
