import Nat "mo:base/Nat"; 
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Prim "mo:prim";
import Char "mo:base/Char";
import Array "mo:base/Array";

actor {
    // challenge 1
    public func nat_to_nat8(n: Nat): async Text {
        // challenge only specifies conversion of Nat to Nat8
        // but without trapping, so to return the value but not trap
        // the following is implemented as:
        if (n < (2*2*2*2*2*2*2*2)) {
            let newNat = Nat8.fromNat(n);
            return Nat8.toText(newNat);
        } else {
            return "Passed natural number exceeding size";
        }
    };

    // challenge 2
    public func max_number_with_n_bits(n: Nat): async Nat {
        return (Nat.pow(2, n) - 1);
    };

    // challenge 3
    public func decimal_to_bits(n: Nat): async Text {
        let remains: Buffer.Buffer<Text> = Buffer.Buffer(32);
        var num: Nat = n;
        while (num > 0) {
            let mod: Nat = num % 2;
            remains.add(Nat.toText(mod));
            num /= 2;
        };

        var returnLiteral: Text = "";
        var index: Nat = remains.size() - 1;
        for (j in Iter.range(0, index)) {
            returnLiteral #= remains.get(index - j);
        };
        
        return returnLiteral;
    };

    // challenge 4 says 'takes a char and returns uppcase' but
    // IDL only accepts nat32 for char arguements, and no checking was asked
    public func capitalize_character(c: Char): async Text {
        let dec: Nat32 = Char.toNat32(c);
        let capitalized = Char.fromNat32(dec - 32);
        return Text.fromChar(capitalized);
    };

    // challenge 5
    public func capitalize_text(t: Text): async Text {
        var count: Nat = 0;
        let newText: Text = Text.map(t, func(c: Char): Char {
            count += 1;
            if (count == 1) {
                return Char.fromNat32(Char.toNat32(c) - 32);
            } else {
                return c;
            };
        });
        return newText;
    };
    
    // challenge 6 note again when passing to this function, at least Candid IDL
    // only accepts the decimal form of the char, not a single char itself
    public func is_inside(t: Text, c: Char): async Bool {
        for (char in t.chars()) { if (c == char) return true; };
        return false;
    };

    // challenge 7
    public func trim_whitespace(t: Text): async Text {
        return Text.trim(t, #char ' ');
    };

    // challenge 8
    public func duplicated_character(t: Text): async Text {
        for (char in t.chars()) {
            if (Text.contains(t, #char char)) { return Text.fromChar(char); }
        };
        return t;
    };

    // challenge 9
    public func size_in_bytes(t: Text): async Nat {
        return Text.encodeUtf8(t).size();
    };

    // challenge 10
    public func bubble_sort(array: [Nat]): async [Nat] {
        let muA = Array.thaw<Nat>(array);
        let len = muA.size();

        var doSwap: Bool = true;
        while (doSwap) {
            doSwap := false;
            for (i in Iter.range(0, len - 2)) {
                let cur: Nat = muA.get(i);
                if (cur > muA[i + 1]) {
                    muA[i] := muA[i + 1];
                    muA[i + 1] := cur;
                    doSwap := true;
                };
            };
        };
        return Array.freeze<Nat>(muA);
    };
} 
