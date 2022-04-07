import SwiftUI

struct DraggableImage: View {
    // Drag Gesture
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    // Roation Gesture
    @State private var rotation: Double = 0.0
    
    // Scale Gesture
    @State private var scale: CGFloat = 1.0
    
    // The different states the frame of the label could be
    private enum WidthState: Int {
        case full, half, third, fourth
    }
    
    @State private var widthState: WidthState = .full
    @State private var currentWidth: CGFloat = 100 //UIScreen.main.bounds.width
    
    var image: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(width: self.currentWidth)
                .lineLimit(nil)
        }
        .scaleEffect(scale) // Scale based on our state
        .rotationEffect(Angle.degrees(rotation)) // Rotate based on the state
        .offset(x: self.currentPosition.width, // Offset from the drag difference from it's current position
                y: self.currentPosition.height)
        .gesture(
            // Two finger rotation
            RotationGesture()
                .onChanged { angle in
                     self.rotation = angle.degrees // keep track of the angle for state
                 }
                 // We want it to work with the scale effect, so they could either scale and rotate at the same time
                 .simultaneously(with:
                                     MagnificationGesture()
                                     .onChanged { scale in
                                         self.scale = scale.magnitude // Keep track of the scale
                                     })
                 // Update the drags new position to be wherever it was last dragged to. (we don't want to reset it back to it's current position)
                 .simultaneously(with: DragGesture()
                                     .onChanged { value in
                                         self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width,
                                                                       height: value.translation.height + self.newPosition.height)
                                     }
                                     .onEnded { value in
                                         self.newPosition = self.currentPosition
                                     })
         )
         /// Have to do double tap first or else it will never work with the single tap
         .onTapGesture(count: 2) {
             // Update our widthState to be the next on in the 'enum', or start back at .full
             self.widthState = WidthState(rawValue: self.widthState.rawValue + 1) ?? .full
             self.currentWidth = UIScreen.main.bounds.width / CGFloat(self.widthState.rawValue)
         }
     }
 }
