import SwiftUI

struct FeedView: View {
    @State private var showingPostView = false
    @State private var showingFilterView = false
    @State var filteringByLocation = false
    @EnvironmentObject private var client: Client

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    HStack {
                        Text("Sidejobs")
                            .font(.title)
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

                    JobListView(endpoint: "/jobs/", filteringByLocation: $filteringByLocation)

                    Spacer()
                }
                .sheet(isPresented: $showingPostView) {
                    PostView()
                }
                .sheet(isPresented: $showingFilterView) {
                    FilterView(filteringByLocation: $filteringByLocation)
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
