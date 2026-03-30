# Multi-City Route Optimization

## When This Applies

Any trip visiting 3+ distinct cities or regions. The order you visit cities
can save days of travel time and hundreds of dollars.

---

## Routing Strategies

### 1. Linear Route (A → B → C → D)
- **Best for:** Countries with one coast, train routes, road trips
- **Advantage:** No backtracking, simple logistics
- **Example:** Tokyo → Kyoto → Osaka → Hiroshima

### 2. Hub-and-Spoke (Base in A, day trip to B, C, D)
- **Best for:** Regions with one major city, avoiding hotel changes
- **Advantage:** Unpack once, flexible day trips
- **Example:** Base in Paris, day trips to Versailles, Giverny, Reims

### 3. Loop (A → B → C → A)
- **Best for:** Open-jaw flights are expensive, rental cars
- **Advantage:** Return to origin, one airport
- **Example:** Rome → Florence → Venice → Rome

### 4. Open-Jaw (Fly into A, out of B)
- **Best for:** Long trips, one-way routes, avoiding backtracking
- **Advantage:** Saves return travel time, often same flight price
- **Example:** Fly into Tokyo, out of Osaka

## Optimization Process

### Step 1: Plot All Cities on a Map
List every city/region the traveler wants to visit.

### Step 2: Build Distance/Time Matrix

| From → To | Distance | Train Time | Flight Time | Drive Time | Cost |
|---|---|---|---|---|---|
| City A → City B | X km | Xh | Xh | Xh | $X |
| City A → City C | X km | Xh | Xh | Xh | $X |
| City B → City C | X km | Xh | Xh | Xh | $X |

### Step 3: Evaluate Routing Options
For each possible order, calculate total travel time and cost.
Recommend the route that minimizes total transit time while
respecting the traveler's preferences.

### Step 4: Consider Constraints
- Flight availability and timing
- Hotel check-in/checkout times
- Activities that are day-specific (markets, events)
- Weekend vs. weekday pricing differences
- One-way rental car drop-off fees
- Visa considerations (multi-country)

## Hub-and-Spoke Analysis

When recommending a base city for day trips:

```
### Hub Analysis — [Region]

**Recommended Hub:** [City]

| Day Trip | Distance | Transit | Duration | Why From Here |
|---|---|---|---|---|
| [City B] | X km | [Mode] Xh | Full day | [Key attraction] |
| [City C] | X km | [Mode] Xh | Half day | [Key attraction] |
| [City D] | X km | [Mode] Xh | Full day | [Worth overnight?] |

**Why this hub:**
- Central location minimizes transit to all day trips
- Best dining/nightlife options for evenings
- Widest accommodation selection
- [Other advantages]

**Alternative hub:** [City] — better if [condition]
```

## Multi-Country Considerations

- [ ] Visa requirements change between countries
- [ ] Currency changes (exchange before crossing)
- [ ] SIM card / phone plan coverage
- [ ] Insurance covers all countries?
- [ ] Border crossing logistics (time, documentation)
- [ ] Time zone changes
- [ ] Language changes (new phrase set needed)
- [ ] Driving side changes (if renting car)
- [ ] Power adapter changes
