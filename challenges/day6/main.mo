import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Array "mo:base/Array";
import List "mo:base/List";
import HTTP "http";
import Text "mo:base/Text";
import Nat16 "mo:base/Nat16";
import Iter "mo:base/Iter";

shared({ caller = installer }) actor class() {
    // challenge 1
    type TokenIndex = Nat;
    type Error = {
        #Error_the_first;
        #Error_Two;
        #Error_of_Three;
        #Error_Quadrupled;
        #Error_March_Ides;
    };

    // challenge 2
    var registry = HashMap.HashMap<TokenIndex, Principal>(0, Nat.equal, Hash.hash);
        // for the sake of forcing myself to learn the syntax of Motoko this approach was used
    var reverseIndexRegistry = HashMap.HashMap<Principal, [TokenIndex]>(0, Principal.equal, Principal.hash);

    // challenge 3
    var nextTokenIndex: Nat = 0;
    type MintError = { 
        #anon: Text; 
        #dne: Text;
    };

    public shared({ caller }) func mint(): async Result.Result<Text, MintError> {
        if (Principal.isAnonymous(caller)) { return #err(#anon("Rando's can't mint!")); };

        // for the challenge
        registry.put(nextTokenIndex, caller);

        let reverseIndexExist = reverseIndexRegistry.get(caller);
        let madeReal = Option.get<[TokenIndex]>(reverseIndexExist, []);
        let updated = Array.append<TokenIndex>(madeReal, [nextTokenIndex]); 
        reverseIndexRegistry.put(caller, updated);
       
        let successMessage = "Mint Successful for user with principal "#(Principal.toText(caller))#" has token index "#(Nat.toText(nextTokenIndex));
        nextTokenIndex += 1;
        // cannot use concat inline with variant eg #ok"Minting done! Thank you user with principal"#Principal.ToText(...) see above
        return #ok(successMessage); // left uncompressed for future self notification
    };

    public shared({ caller }) func getReverse(): async ?[TokenIndex] { 
        return reverseIndexRegistry.get(caller); 
    };

    // challenge 4 
    public shared({ caller }) func transfer(to: Principal, tokenIndex: Nat): async Result.Result<Text, MintError> {
        if (Principal.isAnonymous(caller)) { return #err(#anon("Rando's can't transfer!")); };

        let reverseIndexExist = reverseIndexRegistry.get(caller);
        if (reverseIndexExist == null) { return #err(#dne"You have yet to mint any tokens!") };

        let madeReal = Option.get<[TokenIndex]>(reverseIndexExist, []);
        assert(madeReal.size() != 0);

        let exists = Array.find<TokenIndex>(madeReal, func(a) { a == tokenIndex} );
        if (exists == null) { return #err(#dne("You have not minted token with said index")); };

        if (exists != null) {
            registry.put(tokenIndex, to);
            reverseIndexRegistry.put(caller, Array.filter<TokenIndex>(madeReal, func(a) { a != tokenIndex} ));
        };
        // note to self: there's an easier way to do this
        return #ok(
            "Successfully transfered tokenIndex "
            #(Nat.toText(tokenIndex)
            #" from "#Principal.toText(caller)
            #" to "#Principal.toText(to))
            );
    };

    // challenge 5
    public shared({ caller }) func balance(): async List.List<TokenIndex> {
        let notAnon = Principal.isAnonymous(caller);
        assert(notAnon != true);
        return List.fromArray<TokenIndex>(Option.get<[TokenIndex]>(reverseIndexRegistry.get(caller), []));
    };

    // challenge 6
    public query func http_request(request: HTTP.Request): async HTTP.Response {
        var returnLit: Text = "";
        let nftMintCount = registry.size();
        if (nftMintCount > 0) {
            let lastMinterPrincipal = Iter.toArray<Principal>(registry.vals())[nftMintCount - 1];
            returnLit := "Minting has occured ";
            if (nftMintCount == 1) {
                returnLit #= "once ";
            } else {
                returnLit #= Nat.toText(nftMintCount)#" times ";
            };
            returnLit #= " with agent of principal "#Principal.toText(lastMinterPrincipal)#" being the last to mint.";
        } else {
            returnLit := "No minting has ever occured, contact agent of principal "#Principal.toText(installer);
        };
        let response = {
            body = Text.encodeUtf8(returnLit);
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200: Nat16;
            streaming_strategy = null
        };
        return (response);
    };
    
    // challenge 7
    stable var regDataArr: [(TokenIndex, Principal)] = [];
    stable var revRegDataArr: [(Principal, [TokenIndex])] = [];

    system func preupgrade() {
        regDataArr := Iter.toArray(registry.entries());
        revRegDataArr := Iter.toArray(reverseIndexRegistry.entries());
    };

    system func postupgrade() {
        registry := HashMap.fromIter<TokenIndex, Principal>(regDataArr.vals(), regDataArr.size(), Nat.equal, Hash.hash);
        reverseIndexRegistry := HashMap.fromIter<Principal, [TokenIndex]>(revRegDataArr.vals(), revRegDataArr.size(), Principal.equal, Principal.hash);
        regDataArr := [];
        revRegDataArr := [];
    };

    // nyi challenge 8, etc
}
