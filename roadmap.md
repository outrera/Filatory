# Roadmap

## Battle system

### By class
Actions
- Allow for alternating buttons when tapping
- Generalize code to check for no input for all devices, not just keyboards
- Send signals so progress bars can fill up.
- Add a type the allows for values sliding up and down (targeted areas, Gears of War reload type things)
- Add a "hang" bool that waits for an animation to finish. Replace "noinput"?

MoveClass
- Actual instanced node
- Creates all actions - Load from file?
- Contains refence to theme for visuals
- Handles displaying prompts and reporting the result
- tracks targets of move (enemies, allies, whatever), effects (damage, healing, life leech...) and applies the effect of the move to the target if successful/partially successful.
- Hold animation data for attack?

Entity
- Contains much more than battle system requires for the rest of the engine.
- Contains a list of available moves (MoveClass)
- Contains equipped items / usable items
- Individual body parts? (useful for being able to equip certain armors, not equipping a sword into a missing hand, allowing for prehensile tails, etc)
- AI scripts should be called from here

Items
- Holds visuals and attributes of items.
- Load from file?
- Attack items have to have MoveClass for use.

BattleManager
- Turn logic
- Holds refences to all entities
- Handles placeent of characters, background assets, ambient noise
- Handles valid targeting of moves.

###Questions:
- Load from a file, and if so, what type of file? XML? JSON? .txt?
- How granular is this system? Do we care if someone has one arm, or does everyone regardless of physical features respond similarly?
- How much does the environment need to know to make changes to the environment based on move?
- Does physical location on the map change targeting information?
- Combine Actions and MoveClass?
