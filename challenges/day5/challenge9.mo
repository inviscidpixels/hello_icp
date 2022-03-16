import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";

actor {
    var favoriteNumber = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);
    stable var entries : [(Principal, Nat)] = [];
    stable var transitionCount: Nat = 0;

    system func preupgrade() {
        entries := Iter.toArray(favoriteNumber.entries());
        transitionCount := entries.size();
    };

    system func postupgrade() {
        favoriteNumber := HashMap.fromIter<Principal, Nat>(entries.vals(), 0, Principal.equal, Principal.hash);
        assert(transitionCount == favoriteNumber.size());
        transitionCount := 0;
        entries := [];
    };

    public shared({ caller }) func add_favorite_numberC4(n: Nat): async Text {
        let fvVal = favoriteNumber.get(caller);
        if (fvVal != null) {
            return "You've already registered your number";
        } else {
            favoriteNumber.put(caller, n);
            return "You've successfully registered your number ";
        };
    };

    public shared({ caller }) func show_favorite_number(): async ?Nat { return favoriteNumber.get(caller); };
}
