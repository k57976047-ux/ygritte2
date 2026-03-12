import SwiftUI

struct ChirkMainMenuView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        QuantumTabView()
            .environment(\.managedObjectContext, managedObjectContext)
    }
}
