using DBPrices
using TimeZones
using Dates

opts1 = Dict(
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
		:bc =>	0,
    # BahnCard ID (see https://gist.github.com/juliuste/202bb04f450a79f8fa12a2ec3abcd72d)
		:typ => "E",
    # E: adult: K: child; B: baby -- BUG: child and baby dont work ATM
		:alter => 30
    # age
	  )
  ],
)

opts2 = deepcopy(opts1)
opts2[:travellers][1][:bc] = 1  # BC25

AACHEN_HBF = 8000001
STUTTGART_HBF = 8000096
date = ZonedDateTime(DateTime(2022,10,23,7,39,0,0), tz"Europe/Warsaw")

@info "test now => should not be empty"
@assert prices(AACHEN_HBF, STUTTGART_HBF, date=Dates.now()) |> length > 0

@info "test yesterday => should be empty"
@assert prices(AACHEN_HBF, STUTTGART_HBF, date=Dates.now() - Day(1)) == Any[]

@info "test that BC25 is cheaper than no BC"
p1 = prices(
  AACHEN_HBF, STUTTGART_HBF, date=Dates.now(), opts=opts1
)[1]["price"]["amount"]
p2 = prices(
  AACHEN_HBF, STUTTGART_HBF, date=Dates.now(), opts=opts2
)[1]["price"]["amount"]
@assert p1 > p2
