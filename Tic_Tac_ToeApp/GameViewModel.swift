//
//  GameViewModel.swift
//  Tic_Tac_ToeApp
//
//  Created by eesaack on 2022-07-02.
//

import SwiftUI

final class GameViewModel: ObservableObject {

let columns: [GridItem] = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPrayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        //chek for win condition or draw larter
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContent.humanWin
            return
        }
        if checkForDraw(in: moves) {
            alertItem = AlertContent.draw
            return
        }
        
        isGameBoardDisabled = true
        
        
        //this is old code
        //moves[i] = Move(player: isHumansTurn ? .human : .computer, boardIndex: i)
        //isHumansTurn.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = self.determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            //checking here too but for computer
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContent.computerWin
                return
            }
            if checkForDraw(in: moves) {
                alertItem = AlertContent.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    //if AI can win, then win
    //if AI can't win, then block
    //if AI can't block, then take middle square
    //if AI can't take middle square, take random avaiable square
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //if AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if  winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first!}
            }
        }
        
        //if AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if  winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first!}
            }
        }
        
        //if AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves , forIndex: centerSquare) {
            return centerSquare
        }
        
        //if AI can't take middle square, take random avaiable square
        
        
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool  {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player}
        let playerPositions = Set(playerMoves.map { $0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
     
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
        
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
