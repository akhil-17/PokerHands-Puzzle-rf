import SwiftUI

public struct ColumnConditionsView: View {
    let conditions: [CardCondition]
    let satisfiedColumns: Set<Int>
    let viewModel: CardGridViewModel
    
    public init(conditions: [CardCondition], satisfiedColumns: Set<Int>, viewModel: CardGridViewModel) {
        self.conditions = conditions
        self.satisfiedColumns = satisfiedColumns
        self.viewModel = viewModel
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(60), spacing: 8), count: 5), spacing: 8) {
            ForEach(0..<5) { index in
                TextCardTop(
                    text: viewModel.formatCondition(conditions[index]),
                    textColor: satisfiedColumns.contains(index) ? Color(hex: "BA68C8") : Color(hex: "efefef")
                )
                .animation(.easeInOut, value: satisfiedColumns.contains(index))
            }
        }
        .padding(.leading, 38)
        .padding(.bottom, 0)
    }
} 