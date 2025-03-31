import SwiftUI

public struct SolutionPreviewOverlay: View {
    let viewModel: CardGridViewModel
    
    public init(viewModel: CardGridViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        // Column conditions at the top
                        ColumnConditionsView(
                            conditions: viewModel.columnConditions,
                            satisfiedColumns: Set(0..<5), // All columns are satisfied in solution
                            viewModel: viewModel
                        )
                        
                        HStack(spacing: -4) {
                            // Row conditions on the left
                            RowConditionsView(
                                conditions: viewModel.rowConditions,
                                satisfiedRows: Set(0..<5), // All rows are satisfied in solution
                                viewModel: viewModel
                            )
                            
                            // The grid
                            CardGridView(
                                cards: viewModel.solutionCards,
                                emptyCardVariants: viewModel.emptyCardVariants,
                                selectedCard: nil,
                                onCardTap: { _, _ in },
                                satisfiedRows: Set(0..<5),
                                satisfiedColumns: Set(0..<5),
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.top, 6) // Add 6 points of top padding to shift the grid down
                    
                    Spacer()
                }
        }
    }
} 