# How to use
### utils.lua
Just require it.

```
require('mylibs/utils')
```

### caster.lua
Require it
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
Require it
```
require('mylibs/aggro')
```
The following is API example
```
log(isAggrod())
isInAggro(target.id)
```
