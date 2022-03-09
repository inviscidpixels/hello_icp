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
import List "mo:base/List";

actor {

    // challenge 1 (includes method after testSwap)
    private func swap<T>(array: [var T], j: Nat, i: Nat): [var T] {
        let swap = array[j];
        array[j] := array[i];
        array[i] := swap;
        return array;
    };

    public func testSwap(): async Text {
        var arr: [var Nat] = [var 1, 2, 3];
        arr := swap(arr, 1, 2);
        return Nat.toText(arr[0])#Nat.toText(arr[1])#Nat.toText(arr[2]);
    };

    // challenge 2
    public func init_count(n: Nat): async [Nat] {
        return Array.tabulate<Nat>(n, func(i: Nat): Nat { i; });
    };

    // challenge 3
    public func seven(array: [Nat]): async Text {
        // maybe not the best way to convert an extra text than stripping of tens
        for (i in Iter.range(0, array.size() - 1)) {
            if (Text.contains(Nat.toText(array[i]), #char '7')) {
                return "Seven is found";
            }
        };
        return "Seven not found";
    };

    // challenge 4
    public func nat_opt_to_nat(n: ?Nat, m: Nat): async Nat {
        switch (n) {
            case (null) { m; };
            case (?n) { n; }
        }
    };

    // challenge 5
    public func day_of_the_week(n: Nat): async ?Text {
        switch (n) {
            case (1) { ?"Monday" };
            case (2) { ?"Tuesday" };
            case (3) { ?"Wednesday" };
            case (4) { ?"Thursday" };
            case (5) { ?"Friday" };
            case (6) { ?"Saturday" };
            case (7) { ?"Sunday" };
            case (_) { null; }
        }
    };

    // challenge 6
    public func populate_array(array: [?Nat]): async [Nat] {
        // transform any opt nats into desired nats
        let ft = func (n: ?Nat): Nat {
            switch (n) {
                case (null) { return 0; };
                case (?n) { return n; };
            }
        };
        // declared above to remind myself how to do this
        let f = func (n: ?Nat): Nat { ft(n); };
        return Array.map<?Nat, Nat>(array, f);
    };

    // challenge 7
    public func sum_of_array(array: [Nat]): async Nat {
        let f = func (n: Nat, nb: Nat): Nat { n + nb; };
        return Array.foldLeft(array, 0, f);
    };

    // challenge 8
    public func squared_array(array: [Nat]): async [Nat] {
        let f = func (n: Nat): Nat { n * n };
        return Array.map<Nat, Nat>(array, f);
    };

    // challenge 9
    public func increase_by_index(array: [Nat]): async [Nat] {
        //func mapEntries<A, B>(xs: [A], f: (A, Nat) -> B): [B]
        let f = func (a: Nat, i: Nat): Nat { a + i };
        return Array.mapEntries(array, f);
    };

    // challenge 10
    private func contains<A>(array: [A], a: A, fcn: (A, A) -> Bool): Bool {
        let f = func (aa: A): Bool { return fcn(aa, a); };
        return Array.filter<A>(array, f).size() > 0;
    };

    public func testContains(): async () {
        assert(contains([1, 2, 3], 1, Nat.equal));
        assert(contains([1, 2, 3], 5, Nat.equal));
    };
}
