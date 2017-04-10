//
//  AESCipher.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 4/9/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation


class AESCipher {
    
    // MARK: Fields
    
    private let Nk = 4
    private let Nb = 4
    private let Nr = 10
    
    private let keyBytes: [UInt8]
    private var keySchedule: [UInt32]?
    
    private var state: [[UInt8]]?
    
    
    // MARK: Initialization
    
    init(withKey keyBytes: [UInt8]) {
        self.keyBytes = keyBytes
        self.keySchedule = self.keyExpansion(withKey: self.keyBytes)
    }
    
    
    // MARK: Public methods
    
    func encrypt(withPlainText bytes: [UInt8]) -> [UInt8]? {
        self.initializeCipher(withPlainText: bytes)
        
        self.addRoundKey(forRound: 0)
        
        for round in 1..<self.Nr {
            self.subBytes()
            self.shiftRows()
        }
        
        return nil
    }
    
    
    // MARK: Private methods
    
    private func initializeCipher(withPlainText inputBytes: [UInt8]) {
        assert(inputBytes.count == 16, "Bad input size = \(inputBytes.count). Should be 16 bytes.")
        
        self.state = [[UInt8]](repeating: [UInt8](repeating: 0x00, count: 4), count: 4)
        
        for i in 0..<4 {
            for j in 0..<self.Nb {
                self.state![i][j] = inputBytes[i + 4 * j]
            }
        }
    }
    
    
    private func keyExpansion(withKey keyBytes: [UInt8]) -> [UInt32] {
        var w = [UInt32](repeating: 0x00000000, count: self.Nb * (self.Nr + 1))
        
        for i in 0..<self.Nk {
            w[i] = 0
            w[i] |= UInt32(keyBytes[4 * i]) << 24
            w[i] |= UInt32(keyBytes[4 * i + 1]) << 16
            w[i] |= UInt32(keyBytes[4 * i + 2]) << 8
            w[i] |= UInt32(keyBytes[4 * i + 3])
        }
        
        for i in self.Nk..<self.Nb * (self.Nr + 1) {
            var temp = w[i - 1]
            
            if i % self.Nk == 0 {
                let rcon = UInt32(AESUtils.rcon[i / Nk]) << 24
                temp = self.subWord(self.rotWord(temp)) ^ rcon
            } else {
                temp = self.subWord(temp)
            }
            
            w[i] = w[i - self.Nk] ^ temp
        }
        
        return w
    }
    
    
    private func addRoundKey(forRound round: Int) {
        
        for wordIdx in round * self.Nb..<(round + 1) * self.Nb {
            let keyWord = self.keySchedule![wordIdx]
            
            for stateColIdx in 0..<4 {
                self.state![0][stateColIdx] ^= UInt8(keyWord & 0x000000FF >> 0)
                self.state![1][stateColIdx] ^= UInt8(keyWord & 0x0000FF00 >> 8)
                self.state![2][stateColIdx] ^= UInt8(keyWord & 0x00FF0000 >> 16)
                self.state![3][stateColIdx] ^= UInt8(keyWord & 0xFF000000 >> 24)
            }
        }
        
    }
    
    
    private func subBytes() {
        for row in 0..<4 {
            for col in 0..<self.Nb {
                self.state![row][col] = AESUtils.sbox[Int(self.state![row][col])]
            }
        }
    }
    
    
    private func shiftRows() {
        for row in 0..<4 {
            var newRow = [UInt8](self.state![row])
            for col in 0..<self.Nb {
                newRow[col] = self.state![row][(col + row) % self.Nb]
            }
            self.state![row] = newRow
        }
    }
    
}


fileprivate extension AESCipher {
    
    func subWord(_ word: UInt32) -> UInt32 {
        var result: UInt32 = 0
        
        result |= UInt32(AESUtils.sbox[Int(word & 0xFF000000 >> 24)]) << 24
        result |= UInt32(AESUtils.sbox[Int(word & 0x00FF0000 >> 16)]) << 16
        result |= UInt32(AESUtils.sbox[Int(word & 0x0000FF00 >> 8)]) << 8
        result |= UInt32(AESUtils.sbox[Int(word & 0x000000FF >> 0)]) << 0
        
        return result
    }
    
    
    func rotWord(_ word: UInt32) -> UInt32 {
        var result: UInt32 = 0
        
        result |= (word & 0x0000FF00 >> 8)
        result |= (word & 0x00FF0000 >> 16) << 8
        result |= (word & 0xFF000000 >> 24) << 16
        result |= (word & 0x000000FF) << 24
        
        return result
    }

}


fileprivate class AESUtils {
    
    static var sbox: [UInt8] = {
        
        var result = [UInt8](repeating: 0x00, count: 256)
        
        var p: UInt8 = 1
        var q: UInt8 = 1;
        
        /* loop invariant: p * q == 1 in the Galois field */
    
        repeat {
            /* multiply p by 2 */
            p = p ^ (p << 1) ^ (p & 0x80 != 0 ? 0x1B : 0);
            
            /* divide q by 2 */
            q ^= q << 1;
            q ^= q << 2;
            q ^= q << 4;
            q ^= q & 0x80 != 0 ? 0x09 : 0;
            
            /* compute the affine transformation */
            let xformed = q ^ rotl8(withX: q, shift: 1) ^ rotl8(withX: q, shift: 2) ^ rotl8(withX: q, shift: 3) ^ rotl8(withX: q, shift: 4);
            
            result[Int(p)] = xformed ^ 0x63;
        } while p != 1;
        
        /* 0 is a special case since it has no inverse */
        result[0] = 0x63;
        
        return result
        
    }()
    
    
    static var rcon: [UInt8] = {
        // m(x) = x^8 + x^4 + x^3 + x + 1 // {01} {00011011}
        
        var result = [UInt8](repeating: 0x00, count: 256)
        
        var currentConstant: UInt32 = 0x8D
        for i in 0..<result.count {
            result[i] = UInt8(currentConstant)
            currentConstant <<= 1
            
            if currentConstant > 0xFF {
                currentConstant ^= 0b100011011
            }
        }
        
        return result
        
    }()
    
    
    // #define ROTL8(x,shift) ((uint8_t) ((x) << (shift)) | ((x) >> (8 - (shift))))
    
    private static func rotl8(withX x: UInt8, shift: UInt8) -> UInt8 {
        return UInt8((x << shift) | UInt8(x >> (8 - (shift))))
    }
}


fileprivate extension Array where Iterator.Element == UInt8 {
    
    var hexString: String {
        var result = "["
        
        for i in 0..<self.count {
            if i > 0 {
                result.append(", ")
            }
            
            result.append(String(self[i], radix: 16))
        }
        
        result.append("]")
        
        return result
    }
    
}
