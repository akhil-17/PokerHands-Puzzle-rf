import SwiftUI

public struct CustomBottomNavigationBar: View {
    let onUndoTap: () -> Void
    let onRedoTap: () -> Void
    let onResetTap: () -> Void
    let canUndo: Bool
    let canRedo: Bool
    let canReset: Bool
    let onSolutionPreviewPress: () -> Void
    let onSolutionPreviewRelease: () -> Void
    
    public init(
        onUndoTap: @escaping () -> Void,
        onRedoTap: @escaping () -> Void,
        onResetTap: @escaping () -> Void,
        canUndo: Bool,
        canRedo: Bool,
        canReset: Bool,
        onSolutionPreviewPress: @escaping () -> Void,
        onSolutionPreviewRelease: @escaping () -> Void
    ) {
        self.onUndoTap = onUndoTap
        self.onRedoTap = onRedoTap
        self.onResetTap = onResetTap
        self.canUndo = canUndo
        self.canRedo = canRedo
        self.canReset = canReset
        self.onSolutionPreviewPress = onSolutionPreviewPress
        self.onSolutionPreviewRelease = onSolutionPreviewRelease
    }
    
    public var body: some View {
        HStack {
            // Left stack of buttons with fixed width
            HStack(spacing: 8) {
                // Undo button or placeholder
                if canUndo {
                    Button(action: onUndoTap) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "333333"))
                            .clipShape(Circle())
                    }
                } else {
                    // Placeholder with same dimensions
                    Color.clear
                        .frame(width: 56, height: 56)
                }
                
                // Redo button or placeholder
                if canRedo {
                    Button(action: onRedoTap) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "333333"))
                            .clipShape(Circle())
                    }
                } else {
                    // Placeholder with same dimensions
                    Color.clear
                        .frame(width: 56, height: 56)
                }
            }
            .frame(width: 120) // Fixed width for the left container
            
            Spacer()
            
            // Center button
            Button(action: {}) {
                Image(systemName: "eye.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(hex: "333333"))
                    .clipShape(Circle())
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onSolutionPreviewPress()
                    }
                    .onEnded { _ in
                        onSolutionPreviewRelease()
                    }
            )
            
            Spacer()
            
            // Right stack of buttons with fixed width
            HStack(spacing: 8) {
                // Reset button or placeholder
                if canReset {
                    Button(action: onResetTap) {
                        Image(systemName: "arrow.trianglehead.2.counterclockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "333333"))
                            .clipShape(Circle())
                    }
                } else {
                    // Placeholder with same dimensions
                    Color.clear
                        .frame(width: 56, height: 56)
                }
                
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color(hex: "333333"))
                        .clipShape(Circle())
                }
            }
            .frame(width: 120) // Fixed width for the right container
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 48)
        .background(Color(hex: "191919"))
    }
} 