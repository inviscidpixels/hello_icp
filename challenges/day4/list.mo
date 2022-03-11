module {
    public type List<T> = ?(T, List<T>);

    // challenge 7
    public func is_null<T>(l: List<T>): Bool {
        switch (l) {
            case (null) true;
            case (_) false;
        }
    };

    // challenge 8
    public func last<T>(l: List<T>): ?T {
        switch (l) {
            case (null) null;
            case (?(e, null)) ?e;
            case (?(_, t)) last<T>(t);
        }
        //let convertOptOut: T = switch s {
        //case null 0;
        //case (?T) T;
        //};
    };

    // challenge 9
    public func size<T>(l: List<T>): Nat {
        func f(l: List<T>, count: Nat): Nat {
            switch (l) {
                case (null) count;
                case (?(_, e)) f(e, count+1);
            };
        };
        f(l, 0);
    };
    
    // challenge 10
    public func get<T>(l: List<T>, n: Nat): ?T {
        switch (n, l) {
            case (_, null) null;
            case (0, (?(e, e2))) ?e;
            case (_, (?(_, e))) get<T>(e, n - 1);
        }
    };

    // challenge 11
    public func reverse<T>(l: List<T>): List<T> {
        func f(l: List<T>, r: List<T>): List<T> {
            switch (l) {
                case (null) r;
                case (?(e, e2)) f(e2, ?(e, r));
            }
        };
        return f(l, null);
    };
};
