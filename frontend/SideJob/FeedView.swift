import SwiftUI

struct FeedView: View {
    @State private var showingPostView = false
    @State private var showingFilterView = false
    @State var filteringByLocation = false
    @EnvironmentObject private var client: Client
  
    @EnvironmentObject private var locationObject: LocationManager
    @State private var refreshID = UUID()
    @State var userZipCode = ""
    @State var radius = 100
    @State var isFiltering = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                  HStack {
                        Text("Jobs")
                            .font(.title)
                            .bold()
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            self.showingFilterView = true
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.trailing)
                    }
                    
                    JobListView(endpoint: "/jobs/", filteringByLocation: $filteringByLocation, refreshID: refreshID,
                                radius: $radius, userZipCode: $userZipCode, isFiltering: $isFiltering)
                    .refreshable {
                        self.refreshID = UUID()
                    }
                    Spacer()
                }
                .sheet(isPresented: $showingPostView) {
                    PostView()
                }
                .sheet(isPresented: $showingFilterView) {
                    FilterView(filteringByLocation: $filteringByLocation, userZipCode: $userZipCode, radius: $radius, isFiltering: $isFiltering)
                }
                
                Button(action: {
                    self.showingPostView = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(10)
                }
            }
        }
    }
}
