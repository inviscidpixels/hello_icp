//note the canister:<name>is from dfx.json definition
//import Minter "canister:challenge8"

import Result "mo:base/Result";
import Principal "mo:base/Principal";

actor AnotherCanister {
    type MintError = { 
        #anon: Text; 
        #dne: Text;
    };

    let minter: actor { 
        foo: () -> async Nat;
        foo2: (lit: Text) -> async Text;
        mint: () -> async Result.Result<Text, MintError>
    } = actor("ryjl3-tyaaa-aaaaa-aaaba-cai");

    public func doFoo(): async Nat { return await minter.foo(); };
    public shared({ caller }) func doFoo2(): async Text { return "Caller "#((Principal.toText(caller))#" gets response: "#(await minter.foo2("Hello"))); };

    // challenge 8 
    // note that the caller here is not implicitly piped to the other canister's mint message
    // so that calling minter.mint() where the mint() declaration in that canister uses shared({ caller })
    // will recieve the principle of this canister rather than the caller reference in this call
    public shared({ caller }) func callUponOtherCanisterToMint(): async Result.Result<Text, MintError> {
        let result = await minter.mint();
        return result;
    };
}
