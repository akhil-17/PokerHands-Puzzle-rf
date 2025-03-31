import SwiftUI

public struct RowConditionsView: View {
    let conditions: [CardCondition]
    let satisfiedRows: Set<Int>
    let viewModel: CardGridViewModel
    
    public init(conditions: [CardCondition], satisfiedRows: Set<Int>, viewModel: CardGridViewModel) {
        self.conditions = conditions
        self.satisfiedRows = satisfiedRows
        self.viewModel = viewModel
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(40), spacing: 8), count: 1), spacing: 8) {
            ForEach(0..<5) { index in
                TextCardLeft(
                    text: viewModel.formatCondition(conditions[index]),
                    textColor: satisfiedRows.contains(index) ? Color(hex: "4CAF50") : Color(hex: "efefef")
                )
                .animation(.easeInOut, value: satisfiedRows.contains(index))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.trailing, 8)
    }
} 