# How to use
### utils.lua
Provide various functions.

```
require('mylibs/utils')
```

### caster.lua
Cast spells or use abilities.
```
require('mylibs/caster')
```
The following is API example
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
The following is API example
```
log(isAggrod())
isInAggro(target.id)
```
