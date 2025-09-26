import Foundation
import SwiftUI


struct LessonsGridView: View {
    let lessons: [Lesson]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(lessons) { lesson in
                NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                    LessonCard(lesson: lesson)
                       
                }
            }
        }
        .padding(.top, 8)
    
    }
}
