import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

actor DayOneChallenge {

    var counted :Nat = 0;

    public func add(n :Nat, m :Nat) :async Nat {
        return n + m;
    };

    public func square(n :Nat) :async Nat {
        return n * n;
    };

    public func days_to_second(numberOfDays :Nat) :async Nat {
        return numberOfDays * 24 * 60 * 60;
    };

    public func increment_counter(n :Nat) :async Nat {
        counted += n;
        return counted;
    };

    public func clear_count() :async () {
        counted := 0;
    };

    public func divide(n :Nat, m :Nat) :async Bool {
        return m % n == 0;
    };

    public func is_even(n :Nat) :async Bool {
        return n % 2 == 0;
    };

    public func sum_of_array(array :[Nat]) :async Nat {
        if (array.size() == 0) return 0;
        var sum = 0;
        for (value in array.vals()) { sum += value; };
        return sum;
    };

    public func maximum(array :[Nat]) :async Nat {
        if (array.size() == 0) return 0;
        var max = array[0];
        for (value in array.vals()) { if (max < value) { max := value; }; };
        return max;
    };

    public func remove_from_array(array :[Nat], n :Nat) :async [Nat] {
        let newArray :Buffer.Buffer<Nat> = Buffer.Buffer(array.size());
            for (x in array.vals()) { if (x != n) { newArray.add(x); }; };
        return newArray.toArray();
    };

    public func selection_sort(array :[Nat]) :async [Nat] {
        let mutableArray = Array.thaw<Nat>(array);
        let len = array.size();

        for (i in Iter.range(0, len - 1)) {
            var minIndex :Nat = i;
            for (j in Iter.range(i + 1, len - 1)) {
                if (mutableArray[j] < mutableArray[minIndex]) { 
                    minIndex := j; 
                };
            };
            if (minIndex != i) {
                let val = mutableArray[i];
                mutableArray[i] := mutableArray[minIndex];
                mutableArray[minIndex] := val;
            };
        };
        return Array.freeze<Nat>(mutableArray);
    };
};
