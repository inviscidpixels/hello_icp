import ApodicticEssenceEnum "custom";
import Animal "animal";
import List "mo:base/List";

actor DigitalPersonification {

    // challenge 1 (also see import ApodicticEssenceEnum and custom.mo associated file)
    // why does it have to be declared here first before the fun can return its type since its already imported
    public type ApodicticEssenceEnum = ApodicticEssenceEnum.ApodicticEssenceEnum;

    public func fun(): async ApodicticEssenceEnum {
        return #undefined_nihilist;
    };

    public func foo(): async Bool {
        return true;
    };
    // end of challenge 1 

    // challenge 2 part 2 (also see import Animaltar and animal.mo associated file)
    public type Animal = Animal.Animal;
    let petFish: Animal = {
        energy = 75;
        specie = "Betta Splendens";
    };

    // challenge 3 see animal.mo

    // challenge 4
    public func create_animal_then_takes_a_break(specie: Text, energyPoints: Nat): async Animal {
        let newAnimal: Animal = {
            energy = energyPoints;
            specie = specie;
        };
        return Animal.animal_sleep(newAnimal);
    };

    // challenge 5
    public type List<Animal> = ?(Animal, List<Animal>);
    var animals = List.nil<Animal>();

    // challenge 6
    public func push_animal(animal: Animal): async () { animals := List.push<Animal>(animal, animals); };
    public func get_animals(): async [Animal] { return List.toArray(animals); };

};
