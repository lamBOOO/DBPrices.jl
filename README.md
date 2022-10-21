# DBPrices.jl

A Julia wrapper for the [`db-prices`](https://github.com/juliuste/db-prices) javascript module from [@juliuste](https://github.com/juliuste).

## Installation

```julia
### ] add DBPrices # Not registered yet, download source code!
using Pkg
Pkg.activate(".")
```

## Usage

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
