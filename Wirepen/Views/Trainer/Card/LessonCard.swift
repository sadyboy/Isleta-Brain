import Foundation
import SwiftUI

struct LessonCard: View {
   let lesson: Lesson
   
    var body: some View {
  
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    Image(systemName: "book.fill").foregroundColor(.blue)
                    Spacer()
                    if lesson.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Text(lesson.title)
                    .font(.headline)
                    .lineLimit(2)
                    .overlay(
                        LinearGradient(
                            colors: [.text1, .text2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        Text(lesson.title)
                            .font(.headline)
                            .lineLimit(2)
                    )
                
                
                Text(lesson.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
                
                Divider()
                HStack {
                    Label("+\(lesson.rewards.xp) XP", systemImage: "star.fill")
                        .foregroundColor(.orange)
                    Spacer()
                    HStack(spacing: 4) {
                        Image("orl").renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.white)
                        Text("+\(lesson.rewards.currency)")
                    }
                    .foregroundColor(.blue)
                    
                }
                .font(.caption)
            }
            .padding()
//            .background(Color(UIColor.secondarySystemBackground))
            .background(
                LinearGradient(colors: [.back1, .back2], startPoint: .bottom, endPoint: .top)
            )
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12).stroke(Color.text1, lineWidth: 2)
            })
            .cornerRadius(12)
            .shadow(radius: 1)
        }
    }

