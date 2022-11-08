using DBPrices
using Dates
using TimeZones
using Plots

AACHEN_HBF = 8000001
STUTTGART_HBF = 8000096
opts = Dict(
  :class => 2,
  # 1st class or 2nd class
  :noICETrains => false,
  :transferTime => 0,
  # in minutes
  :duration => 1,
  # search for routes in the next n minutes
  :preferFastRoutes => true,
  :travellers => [ # one or more
    Dict(
      :bc => 1,
      # BahnCard ID (see https://gist.github.com/juliuste/202bb04f450a79f8fa12a2ec3abcd72d)
      :typ => "E",
      # E: adult: K: child; B: baby -- BUG: child and baby dont work ATM
      :alter => 30
      # age
    )
  ],
)

date1 = ZonedDateTime(DateTime(2022,10,24,7,39,0,0), tz"Europe/Warsaw")
dates_ar1 = []
prices_ar1 = []
for i=0:27
  newdate = date1+Week(i)
  price = 0
  try
    res = prices(AACHEN_HBF, STUTTGART_HBF, date=newdate, opts=opts)
    journey = res[1]
    price = journey["price"]["amount"]
  catch e
    price = NaN
  end
  push!(dates_ar1, newdate)
  push!(prices_ar1, price)
  println(
    string(dayofweek(newdate)) * "," * string(newdate) * "," * string(price)
  )
end
plot(Date.(dates_ar1), prices_ar1, marker=:circle, labels="Ticket Price", xaxis="Date", yaxis="Ticket price", title="DB Prices for MO 7:39 AC -> STU") |> display

date2 = ZonedDateTime(DateTime(2022,10,27,15,23,0,0), tz"Europe/Warsaw")
dates_ar2 = []
prices_ar2 = []
for i=0:27
  newdate = date2+Week(i)
  price = 0
  try
    res = prices(STUTTGART_HBF, AACHEN_HBF, date=newdate, opts=opts)
    journey = res[1]
    price = journey["price"]["amount"]
  catch e
    price = NaN
  end
  push!(dates_ar2, newdate)
  push!(prices_ar2, price)
  println(
    string(dayofweek(newdate)) * "," * string(newdate) * "," * string(price)
  )
end
plot(Date.(dates_ar2), prices_ar2, marker=:circle, labels="Ticket Price", xaxis="Date", yaxis="Ticket price", title="DB Prices for DO 15:23 STU -> AC") |> display
