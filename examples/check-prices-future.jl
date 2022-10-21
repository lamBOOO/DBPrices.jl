using DBPrices
using Dates
using TimeZones

AACHEN_HBF = 8000001
STUTTGART_HBF = 8000096
date = ZonedDateTime(DateTime(2022,10,23,7,39,0,0), tz"Europe/Warsaw")
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
		:bc =>	1,
    # BahnCard ID (see https://gist.github.com/juliuste/202bb04f450a79f8fa12a2ec3abcd72d)
		:typ => "E",
    # E: adult: K: child; B: baby -- BUG: child and baby dont work ATM
		:alter => 30
    # age
	  )
  ],
)

for i=0:100
  newdate = date+Day(i)
  res = prices(AACHEN_HBF, STUTTGART_HBF, date=newdate)
  journey = res[1]
  println(string(dayofweek(newdate)) * "," * string(newdate) * "," * string(journey["price"]["amount"]))
end
