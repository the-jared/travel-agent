# Maps, Routes & Navigation Guide

## Core Principle

Every location mentioned in any deliverable MUST include a clickable link.
Every transit between locations MUST include step-by-step directions.
The traveler should never wonder "how do I get there?"

---

## Google Maps Links — Always Include

For EVERY location mentioned anywhere in the trip folder, generate:

### Point Links
- **Google Maps:** `https://www.google.com/maps/search/?api=1&query=[name+address+encoded]`
- **Apple Maps:** `https://maps.apple.com/?q=[name+address+encoded]`
- **Google Maps Place ID (if known):** `https://www.google.com/maps/place/?q=place_id:[ID]`

### Route Links (Between Two Points)
- **Google Maps Directions:**
  `https://www.google.com/maps/dir/[origin]/[destination]`
- **With transit mode:**
  `https://www.google.com/maps/dir/?api=1&origin=[A]&destination=[B]&travelmode=[driving|walking|transit|bicycling]`
- **Apple Maps Directions:**
  `https://maps.apple.com/?daddr=[destination]&dirflg=[d|w|r]`
  (d=driving, w=walking, r=transit)

### Multi-Stop Routes
For day itineraries with 3+ stops, generate a multi-stop Google Maps route:
`https://www.google.com/maps/dir/[stop1]/[stop2]/[stop3]/[stop4]`

This lets the traveler open the entire day's walking route in one tap.

## Step-by-Step Direction Templates

### Airport → Hotel

```
## Getting from [Airport] to [Hotel]

**Best option:** [Mode] — [Duration] — [Cost]

### Step-by-step:
1. After clearing customs, follow signs to [Transit/Taxi/etc.]
2. [Specific directions — which exit, which platform, which bus number]
3. [Transfer instructions if applicable]
4. [Final leg — walk X meters, turn left at Y]
5. Arrive at [Hotel Name]

**Google Maps route:** [link]
**Apple Maps route:** [link]

**Alternatives:**
- Taxi: ~$X, [duration], [where to queue, what to tell driver]
- Ride-hailing: Open [App], ~$X, [duration]
- Hotel shuttle: [If available — how to arrange]
```

### Between Daily Activities

For EACH transition in the day itinerary:

```
**[Activity A] → [Activity B]**
- Mode: [Walk / Metro / Taxi / Bus]
- Duration: [X minutes]
- Distance: [X km]
- Route: [brief description — "walk south on [Street], turn right at [Landmark]"]
- Google Maps: [direct route link]
- Cost: [if applicable]
- Notes: [scenic route option, avoid at rush hour, etc.]
```

## Offline Maps Preparation

Include in every trip folder:
- [ ] Download Google Maps offline area for [City/Region]
  - How: Google Maps → Profile → Offline maps → Select area
  - Size estimate: ~[X] MB
- [ ] Download Maps.me offline map for [Country]
  - Backup offline map app, works without data
- [ ] Screenshot key transit maps (metro/bus)
- [ ] Save key addresses in local script (for showing to taxi drivers)

## Navigation Tips Per Destination

### Addressing Systems
Note if the destination has unusual addressing:
- Japan: Block-based, not street-based — always use Google Maps, not addresses
- Costa Rica: Landmark-based directions ("200m south of the red church")
- Dubai: Under construction — maps may be outdated
- Rural areas: GPS coordinates may be more reliable than addresses

### Walking Route Quality
- [ ] Sidewalk availability and quality
- [ ] Pedestrian crossing safety
- [ ] Hills/stairs (important for accessibility, luggage)
- [ ] Shade availability (important in hot climates)
- [ ] Safety for walking at night (stick to main roads?)

### Useful Map Layers
- Google Maps satellite view: Check if "scenic walk" is actually along a highway
- Google Maps Street View: Preview unfamiliar areas
- Transit overlay: See metro/bus routes
- Terrain: Important for hiking/cycling planning
