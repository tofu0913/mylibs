# How to use
### utils.lua
Provide various functions.

```
require('mylibs/utils')
```
Example
```
checkDeBuffs()
isInParty(p3.id)
```

### caster.lua
Cast spells or use abilities.
```
require('mylibs/caster')
```
Example
```
cast_init()
add_spell('so', '猛者のメヌエットV')
cast_all()
```

### aggro.lua
Aggro tracker.
```
require('mylibs/aggro')
```
Example
```
isAggrod()
isInAggro(target.id)
```
