//
//  ContentView.swift
//  OddOneOut
//
//  Created by pat on 1/5/23.
//

import SwiftUI

struct ContentView: View {
    static let gridSize = 10
    @State var images = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
    @State var layout = Array(repeating: "empty", count: gridSize * gridSize)
    @State var currentLevel = 1
    @State var isGameOver = false
    
    func image(_ row: Int, _ column: Int) -> String {
        layout[row * Self.gridSize + column]
    }
    func generateLayout(nAnimals: Int) {
        layout.removeAll(keepingCapacity: true)
        
        images.shuffle()
        layout.append(images[0])
        
        var nPlacements = 0
        var animalIndex = 1
        for _ in 1 ..< nAnimals {
            layout.append(images[animalIndex])
            nPlacements += 1
            
            if nPlacements == 2 {
                nPlacements = 0
                animalIndex += 1
            }
            if animalIndex == images.count {
                animalIndex = 1
            }
        }
        layout += Array(repeating: "empty", count: 100 - layout.count)
        layout.shuffle()
    }
    func createLevel() {
        if currentLevel == 9 {
            withAnimation {
                isGameOver = true
            }
        } else {
            let numberOfItems = [0, 5, 15, 25, 35, 49, 65, 81, 100]
            generateLayout(nAnimals: numberOfItems[currentLevel])
        }
    }
    func processAnswer(at row: Int, _ column: Int) {
        if image(row, column) == images[0] {
            currentLevel += 1
            createLevel()
        } else {
            if currentLevel > 1 { currentLevel -= 1 }
            createLevel()
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Odd One Out")
                    .font(.system(size: 36, weight: .thin))
                    .fixedSize()
                ForEach(0..<Self.gridSize, id: \.self) { row in
                    HStack {
                        ForEach(0..<Self.gridSize, id: \.self) { column in
                            if image(row, column) == "empty" {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 64, height: 64)
                            } else {
                                Button {
                                    print("Penguin was clicked")
                                    processAnswer(at: row, column)
                                } label: {
                                    Image(image(row, column))
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }
            .opacity(isGameOver ? 0.2 : 1)
            if isGameOver {
                VStack {
                    Text("Game over!")
                        .font(.largeTitle)
                    
                    Button("Play Again") {
                        currentLevel = 1
                        isGameOver = false
                        createLevel()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .buttonStyle(.borderless)
                    .padding(20)
                    .background(.blue)
                    .clipShape(Capsule())
                }
            }
        }
        .onAppear(perform: createLevel)
        .contentShape(Rectangle())
        .contextMenu {
            Button("Start New Game") {
                currentLevel = 1
                isGameOver = false
                createLevel()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
