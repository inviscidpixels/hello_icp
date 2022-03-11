module {
    // challenge 2 part 1
    public type Animal = {
        energy: Nat;
        specie: Text;
    };

    // challenge 3: 
    // cannot return the "same animal" and also 
    // mutate energy so here's "the next best thing"
    public func animal_sleep(animal: Animal): Animal {
        let a: Animal = {
            energy = animal.energy + 10;
            specie = animal.specie;
        };
        return a;
    };
}



