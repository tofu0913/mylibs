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
isJob(job name)
isSubJob(job name)
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

### caster_lite.lua
For some case you cannot use action handler, ex: GearSwap
```
require('mylibs/caster_lite')
```
Same APIs with caster

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

### fsd_lite.lua
Better coding performance for FSD
```
require('mylibs/fsd_lite')
```
Example
```
fsd_go(addon shortcut, fsd path, callback function)
```
