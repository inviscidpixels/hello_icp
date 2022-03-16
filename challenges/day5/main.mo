import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Cycles "mo:base/ExperimentalCycles";

shared({ caller = CAN_INSTALLER }) actor class() {
 
  let CAN_ANONYMOUS_PRINCIPLE: Principal = Principal.fromText("2vxsx-fae");
  public func get_creator(): async Principal { CAN_INSTALLER; };

  public shared({ caller }) func greet() : async Text {
    if (Principal.equal(caller, CAN_INSTALLER)) { return "Hello creator!"; };
    if (Principal.equal(caller, CAN_ANONYMOUS_PRINCIPLE)) { return "Howdy stranger!"; };
    return "Greetings to the authenticated user"; 
    //how to use switch here instead
  };

  // challenge 1
  public shared({ caller = curControllerCxt }) func is_anonymous() : async Bool {
      return Principal.isAnonymous(curControllerCxt);
  };

  // challenge 2
  private var favoriteNumber = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);

  // challenge 3 part 1
  public shared({ caller }) func add_favorite_number(n: Nat): async Bool {
      if (Principal.isAnonymous(caller)) { return false; }; 
      favoriteNumber.put(caller, n); 
      return true;
  };

  // challenge 3 part 2
  public shared({ caller }) func show_favorite_number(): async ?Nat {
      if (Principal.isAnonymous(caller)) { return null; }; 
      return favoriteNumber.get(caller);
  };

  // challenge 4
  public shared({ caller }) func add_favorite_numberC4(n: Nat): async Text {
      if (Principal.isAnonymous(caller)) { return "Random users don't get to save their favorite numbers, consider getting an internet identity if you want to use the internet."; }; 
      let fvVal = favoriteNumber.get(caller);
      if (fvVal != null) {
        return "You've already registered your number";
      } else {
        favoriteNumber.put(caller, n);
        return "You've successfully registered your number ";
      };
      //note on the fact using defined show_favorite_number indirectly will cause problem as it can return opt instead of text
  };

  // challenge 5 part 1
  public shared({ caller }) func update_favorite_number(n: Nat): async Text {
      if (Principal.isAnonymous(caller)) { return "Random users don't get to save their favorite numbers, consider getting an internet identity if you want to use the internet."; }; 
      let previousfvVal = favoriteNumber.replace(caller, n);
      if (previousfvVal == null) {
        return "Successfully registered value "; //#Nat.toText(n);
      } else {
        return "Successfully updated registered value"; //convert opt to show as "Updated from <prev> to <current ie n>"
      };
  };

  // challenge 5 part 2
  public shared({ caller }) func remove_favorite_number(): async Text {
      if (Principal.isAnonymous(caller)) { return "Random users don't get to save their favorite numbers, consider getting an internet identity if you want to use the internet."; }; 
      let previousfvVal = favoriteNumber.remove(caller);
      if (previousfvVal == null) {
          return "No value registered to remove!";
      } else {
        return "Value removed as expected!";
      }
  };

  public func balance(): async Nat { return (Cycles.balance()); };
  public func cycles_from_message(): async Nat { return (Cycles.available()); };

  // challenge 6
  public func deposit_cycles(): async Nat {
      let amount = Cycles.available(); 
      var accepted = 0;
      if (amount > 0) { accepted := Cycles.accept(amount); };
      return accepted;
  };

  // challenge 7
  public shared({ caller }) func withdraw(amount: Nat, _deposit_cycles: shared() -> async()): async () {
      assert(caller == CAN_INSTALLER);
      if (amount < Cycles.balance()) { Cycles.add(amount); };
      await _deposit_cycles();
  };

  // challenge 8 
  stable var counted: Nat = 0;
  stable var versionNumber: Nat = 1;
  public func increment_counter(n : Nat) :async Nat {
      counted += n;
      return counted; 
  };

  system func postupgrade() { versionNumber += 1; };
};

