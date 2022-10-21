# DBPrices.jl

A Julia wrapper for the [`db-prices`](https://github.com/juliuste/db-prices) javascript module from [@juliuste](https://github.com/juliuste).

Exports one function
```julia
prices(from::Integer, to::Integer, date=Dates.now(), opts = DEF_OPTS)
```
to get Deutsche Bahn (DB) journey information.

## Installation

```julia
### ] add DBPrices # Not registered yet, download source code!
using Pkg
Pkg.activate(".")
```

## `prices` function

```julia
DEF_OPTS = Dict(
  :class => 2,
  # 1st class or 2nd class
  :noICETrains => false,
  :transferTime => 0,
  # in minutes
  :duration => 1440,
  # search for routes in the next n minutes
  :preferFastRoutes => true,
  :travellers => [ # one or more
    Dict(
    :bc =>  0,
    # BahnCard ID (see https://gist.github.com/juliuste/202bb04f450a79f8fa12a2ec3abcd72d)
    :typ => "E",
    # E: adult: K: child; B: baby -- BUG: child and baby dont work ATM
    :alter => 30
    # age
    )
  ],
)

# API, same in in @juliuste/db-prices
# db station integers can be obtained from @derhuerst/db-stations
# https://github.com/derhuerst/db-stations/
prices(from::Integer, to::Integer, date=Dates.now(), opts = DEF_OPTS)
```


## Tutorial

```julia
julia> results = prices(8000001, 8000096);

julia> length(results)  # returns multiple journeys
10

# check some journey
julia> results[1]
# Dict{String, Any} with 7 entries:
#   "price"       => Dict{String, Any}("amount"=>134, "name"=>"Flexpreis", "currency"=>"EUR", "anyTrain"=>true, "discount"=>false, "description"=>"With an ICE ticket you can use all trains on the…
#   "destination" => Dict{String, Any}("name"=>"Stuttgart Hbf", "id"=>"8000096", "type"=>"station")
#   "id"          => "0"
#   "nightTrain"  => false
#   "type"        => "journey"
#   "legs"        => Any[Dict{String, Any}("line"=>Dict{String, Any}("name"=>"ICE  317", "mode"=>"train", "id"=>"ice-317", "product"=>"ICE", "type"=>"line"), "destination"=>Dict{String, Any}("nam…
#   "origin"      => Dict{String, Any}("name"=>"Aachen Hbf", "id"=>"8000001", "type"=>"stati

# check connections within journey
julia> map(leg->string(leg["origin"]["name"] * " ------> " * leg["destination"]["name"] * " @ " * leg["line"]["name"]), results[1]["legs"])
# 2-element Vector{String}:
#  "Aachen Hbf ------> F-Flughafen Fernbf. @ ICE  317"
#  "F-Flughafen Fernbf. ------> Stuttgart Hbf @ ICE  771"
```

## Examples
See [`./examples`](./examples) folder.
