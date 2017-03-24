# Functions

Get the username of a specified USGN ID (returns a number)
```lua
convert.toName(usgn)
```

Get the USGN ID of a specified username (returns a string)
```lua
convert.toUSGN(name)
``` 
> Note: Returns an empty value if the specified username/id does not exist!


Get USGN server status (returns a boolean)
```lua
convert.usgnstatus()
```


# Prerequisites
* curl
* wget (optional)
