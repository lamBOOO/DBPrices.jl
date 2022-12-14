module DBPrices

using Dates
using JSON
using NodeJS
using TimeZones

export prices

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
        :bc =>    0,
    # BahnCard ID (see https://gist.github.com/juliuste/202bb04f450a79f8fa12a2ec3abcd72d)
        :typ => "E",
    # E: adult: K: child; B: baby -- BUG: child and baby dont work ATM
        :alter => 30
    # age
      )
  ],
)

function prices(from::Integer, to::Integer; date=Dates.now(), opts=DEF_OPTS)
  io = IOBuffer();
  cmd = Cmd([
    nodejs_cmd().exec[1],
    "-e",
    """
    const prices = require('db-prices');
    const date = new Date('$(string(date))');
    prices('$from', '$to', date, $(JSON.json(opts))).then((val)=>{
      console.log(JSON.stringify(val))
    })
    """
  ])
  run(pipeline(cmd, stdout=io))
  res = JSON.parse(String(take!(io)))
  return res
end

end # module DBPrices
