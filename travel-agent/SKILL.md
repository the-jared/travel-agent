---
name: travel-agent
description: >-
  Comprehensive end-to-end travel planning skill that replaces a human travel agent.
  This skill should be used when planning trips, researching destinations, comparing
  accommodations/flights, generating itineraries, creating packing checklists, or
  finding hidden gems through local-language research. Supports full wizard mode
  and modular sub-commands for targeted research.
---

# Travel Agent — Premium Trip Planning

A comprehensive travel planning system that produces obsessively thorough,
nothing-missed trip documentation. Dispatches parallel research agents across
multiple sources, languages, and channels to deliver premium-grade travel guidance.

## Sub-Commands

| Command | Purpose |
|---|---|
| `/travel-agent` | Full wizard: intake → parallel research → synthesis → trip folder |
| `/travel-agent:research <destination>` | Deep destination research only |
| `/travel-agent:itinerary` | Build/refine day-by-day itinerary from existing research |
| `/travel-agent:checklist` | Generate all checklists for a planned trip |
| `/travel-agent:compare` | Side-by-side comparison of options (hotels, flights, areas) |
| `/travel-agent:hidden-gems <destination>` | Local-language deep-dive for off-radar spots |
| `/travel-agent:budget` | Full cost modeling across budget/mid/luxury tiers |

---

## Phase 1: Intake — Traveler Profile & Preferences

Before any research begins, gather the complete traveler profile. Ask these
questions interactively, one at a time. Do not skip any.

### Required Information (Must-Have)

1. **Destination(s)** — Where? Single city, multi-city, country-wide, multi-country?
2. **Dates** — When? Exact dates or flexible window? Duration?
3. **Travelers** — How many? Ages? Couples, families, solo, group?
4. **Budget tier** — Budget / Mid-range / Luxury / Ultra-luxury? Or a dollar amount?
5. **Travel style** — Adventure / Relaxation / Cultural / Foodie / Nightlife / Mix?
6. **Accommodation preference** — Hotels / Airbnb / Hostels / Boutique / Ryokan-style / Mix?
7. **Must-do list** — Any non-negotiable experiences or places?
8. **Dietary restrictions** — Allergies, vegetarian/vegan, halal, kosher, etc.?
9. **Mobility considerations** — Any accessibility needs?
10. **Origin city** — For flight research and time zone context.
11. **Return flexibility** — Fixed return or open-ended?
12. **Visa status** — Current passport country? Any existing visas?
13. **Health conditions** — Altitude sensitivity, motion sickness, medication needs?
14. **Connectivity needs** — Must have WiFi? Remote work requirements?
15. **Loyalty programs** — Airline, hotel, credit card points to leverage?
16. **Travel insurance** — Already have it? Want recommendations?
17. **Luggage constraints** — Carry-on only? Checked bags? Gear to bring?
18. **Group dynamics** — Decision-maker? Split preferences in the group?
19. **Celebration/occasion** — Anniversary, birthday, honeymoon, retirement?
20. **Hard constraints** — Anything absolutely ruled out (heights, boats, spicy food)?

### Nice-to-Have (Ask If Not Volunteered)

21. **Pace preference** — Packed schedule vs. lazy mornings vs. balanced?
22. **Photography priorities** — Sunrise/sunset spots, Instagram locations?
23. **Shopping interests** — Markets, luxury, local crafts, specific items?
24. **Wellness** — Spa, onsen, yoga, meditation retreats?
25. **Nightlife** — Bars, clubs, live music, wine bars, craft cocktails?
26. **Kid-friendly needs** — Stroller access, nap schedules, kid menus?
27. **Pet travel** — Traveling with pets?
28. **Previous visits** — Been to this destination before? What to skip/revisit?
29. **Languages spoken** — For local interaction comfort level
30. **Risk tolerance** — Adventurous (street food, off-grid) vs. play-it-safe?
31. **Transportation preferences** — Love trains? Hate buses? Road trip fan?
32. **Sleep preferences** — Early bird? Night owl? Need blackout curtains?
33. **Social preferences** — Want to meet locals? Other travelers? Stay private?
34. **Learning interests** — Cooking classes, language lessons, craft workshops?
35. **Nature vs. urban** — Prefer wilderness, cities, or a mix?
36. **Tech comfort** — Will use apps? Prefer paper maps? Need offline everything?
37. **Souvenir budget** — Plan to bring things home? Shipping needs?
38. **Fitness level** — Can handle long hikes? Prefer minimal walking?
39. **Climate preference** — Tolerate heat well? Need air conditioning?
40. **Splurge priorities** — Where to spend big vs. where to save?

### Advanced Domain Triggers

If the traveler mentions any of these, read `references/advanced-planning-domains.md`
and incorporate the relevant domain checklist:
- Working remotely → Digital Nomad section
- Wheelchair / accessibility → Inclusive Travel section
- Kids / family → Family Travel section
- Luxury / splurge → Luxury Planning section
- Hiking / climbing / diving → Adventure section
- Wellness / spa / yoga → Health Tourism section
- Learning / cooking class → Cultural Immersion section
- Festival / concert / event → Event-Based section
- Shopping / souvenirs → Shopping Intelligence section
- Points / miles / hacking → Travel Optimization section

Once intake is complete, confirm the profile back to the user and proceed.

---

## Phase 2: Parallel Research Dispatch

After intake confirmation, dispatch **10 parallel research agents** using the Agent tool.
Each agent receives the full traveler profile and its specific research brief.

Read the corresponding `references/` file before dispatching each agent to load
domain-specific methodology.

### Agent 1: Country & Culture Deep-Dive
- **Reference:** Read `references/country-knowledge-template.md`
- **Brief:** Research the destination country/region comprehensively. Cover geography, climate during travel dates, political situation, economic context, infrastructure quality, regional differences, and practical daily-life details (tipping, bargaining, queuing culture). Search government travel advisories, expat blogs, and recent traveler reports.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `02-country-guide.md`

### Agent 2: Accommodation Research
- **Reference:** Read `references/accommodation-analysis.md`
- **Brief:** Search Booking.com, Airbnb, hotel aggregators, boutique hotel blogs, and local accommodation sites. Compare across budget tiers. Note cancellation policies, location pros/cons, transit access, nearby dining, and guest review summaries. Flag any accommodation that matches the traveler's style especially well.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `03-accommodations.md`

### Agent 3: Transport Research
- **Reference:** Read `references/transport-analysis.md`
- **Brief:** Flights, trains, buses, ferries, car rental, rideshare, local transit. Research booking platforms, pass options, loyalty program relevance, airport transfer options, and inter-city routes. Include journey times, costs, comfort levels, and booking links. Note any transport strikes or disruptions.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `04-transport.md`

### Agent 4: Hidden Gems — Local Language Research
- **Reference:** Read `references/hidden-gems-methodology.md`
- **Brief:** Search in LOCAL LANGUAGE of destination. Find neighborhood blogs, local review sites, regional forums, and social media posts. Translate findings back. Focus on places tourists rarely find: neighborhood restaurants, local markets, viewpoints, cultural events, artisan workshops, and off-the-beaten-path experiences.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `06-hidden-gems.md`

### Agent 5: Food & Dining
- **Reference:** Read `references/food-and-dining.md`
- **Brief:** Michelin and local award winners, neighborhood favorites, street food hotspots, dietary-safe options, food tours, cooking classes, market visits, and food halls. Organize by meal type, neighborhood, budget tier, and dietary compatibility. Include reservation requirements and booking links.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `05-food-guide.md`

### Agent 6: Activities & Experiences
- **Reference:** Read `references/activities-experiences.md`
- **Additional Reference:** Read `references/visual-research.md`
- **Brief:** Tours, cultural sites, seasonal events, day trips, unique experiences, adventure activities, workshops, performances, and sporting events. Tag each with duration, cost, booking requirement, and physical intensity. Include sunrise/sunset times, photography spots, and YouTube walkthrough links.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `07-activities.md` and `14-photo-guide.md`

### Agent 7: Maps, Routes & Navigation
- **Reference:** Read `references/maps-and-routes.md`
- **Brief:** Generate Google Maps and Apple Maps links for every location mentioned by other agents. Create step-by-step directions between all activities. Compile offline map download instructions. Build walking route suggestions for each neighborhood. Generate multi-stop day route links. Save key addresses in local script for taxi drivers.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `13-maps-and-routes.md`

### Agent 8: Cultural Intelligence & Language
- **Reference:** Read `references/local-cultural-intelligence.md`
- **Brief:** Compile top 80 local phrases with pronunciation guide. Research deep cultural do's and don'ts from both local and tourist sources. Build a "Big 5" most important cultural rules highlight. Create a quick reference card. Gather real traveler "things I wish I knew" insights from forums, Reddit, and travel blogs.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `02-country-guide.md` (cultural sections)

### Agent 9: Booking Timing & Price Intelligence
- **Reference:** Read `references/booking-timing.md`
- **Brief:** Research optimal booking windows for all flights, hotels, and activities. Identify which bookings are time-sensitive vs. flexible. Find price tracking tools and alert services. Generate a booking timeline countdown specific to this trip with exact "book by" dates and links.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content for `16-booking-timeline.md`

### Agent 10: Seasonal Events & Calendar
- **Reference:** Read `references/seasonal-events-calendar.md`
- **Brief:** Research all events, festivals, public holidays, closures, and seasonal phenomena during the trip dates at the destination. Include religious observances, school holidays, local celebrations, sporting events, concerts, exhibitions, and natural events (cherry blossoms, northern lights, whale migration, etc.). Note crowd impact and booking implications.
- **Tools:** WebSearch, WebFetch
- **Deliverable:** Content integrated into `01-itinerary.md` and `07-activities.md`

### Dispatch Pattern

```
Launch all 10 agents in parallel using the Agent tool in a single message.
Each agent prompt must include:
1. The full traveler profile from Phase 1
2. The methodology from its reference file
3. Clear output format instructions matching the template structure
4. Instruction to use WebSearch and WebFetch extensively
5. Instruction to search in BOTH English AND local language(s)
```

---

## Phase 3: Synthesis — Build the Trip Folder

After all agents return, synthesize their research into the complete trip folder.

### Step 3a: Run init-trip.sh
Execute `scripts/init-trip.sh <trip-name>` to scaffold the output folder.

### Step 3b: Write 02-country-guide.md
Merge Agent 1 and Agent 8 output with the template from `assets/templates/country-guide-template.md`.
Include cultural intelligence sections, phrase guide, and do's/don'ts from Agent 8.

### Step 3c: Write 03-accommodations.md
Merge Agent 2 output. Ensure comparison tables across budget tiers.
Include cancellation policies, location maps, and transit access notes.

### Step 3d: Write 04-transport.md
Merge Agent 3 output. Include route maps, pass recommendations, booking links.
Add journey time comparisons and cost breakdowns per route.

### Step 3e: Write 05-food-guide.md
Merge Agent 5 output. Organize by meal type, area, and budget tier.
Include dietary safety ratings, reservation requirements, and map links.

### Step 3f: Write 06-hidden-gems.md
Merge Agent 4 output. Flag which items came from local-language sources.
Include difficulty-to-find ratings and specific directions.

### Step 3g: Write 07-activities.md
Merge Agent 6 and Agent 10 output. Tag each with duration, cost, booking requirement.
Integrate seasonal events and festival information from Agent 10.

### Step 3h: Build 01-itinerary.md
Cross-reference ALL agent outputs to build the day-by-day itinerary.
Read `references/itinerary-builder.md` for the synthesis methodology.
Use `assets/templates/itinerary-template.md` for the output format.
Integrate seasonal events from Agent 10 into the appropriate days.

### Step 3i: Build 08-budget.md
Read `references/budget-framework.md`. Aggregate costs from all agents.
Present 3 tiers: Budget / Mid-range / Luxury with line-item breakdowns.
Include booking timeline costs from Agent 9.

### Step 3j: Build 09-checklists.md
Read `references/checklist-master.md`. Generate ALL applicable checklists
customized to this specific trip (destination, season, activities, traveler profile).
Read `references/packing-weight-budget.md` for packing optimization.

### Step 3k: Build 10-bookings.md
Compile all booking links, comparison tables, and action items from all agents.
Organize by urgency: "Book Now" vs "Book 2 Weeks Before" vs "Book On Arrival".
Cross-reference with Agent 9 booking timeline data.

### Step 3l: Build 11-plan-b.md
For each day in the itinerary, generate rainy-day alternatives, indoor options,
and flexible rebooking suggestions. Include emergency contacts and nearest hospitals.
Read `references/alternatives-framework.md` for the contingency methodology.

### Step 3m: Build 12-pocket-guide.md
A condensed, phone-friendly daily reference with essential phrases, emergency
numbers, key addresses, and quick-reference cultural notes.
Include taxi cards and key phrases from Agent 8.

### Step 3n: Build 00-overview.md
Fill in the overview with trip details and a summary of all findings.
Include links to all deliverable files and a trip-at-a-glance summary.

### Step 3o: Build 13-maps-and-routes.md
Merge Agent 7 output. For every transit leg in the itinerary,
generate a step-by-step guide with numbered instructions, map links, and photos.
Read `references/maps-and-routes.md` for formatting standards.

### Step 3p: Build 14-photo-guide.md
Extract visual research from Agent 6. Include sunrise/sunset times per location,
golden hour windows, photography spots with GPS coordinates, and YouTube
walkthrough links. Read `references/visual-research.md` for structure.

### Step 3q: Build 15-alternatives.md
Read `references/alternatives-framework.md`. For every recommendation in every
file, add an "Alternatives" section with backup options. Consolidate into
a master alternatives reference organized by category.

### Step 3r: Build 16-booking-timeline.md
Read `references/booking-timing.md`. Use `assets/templates/booking-timeline.md`.
Generate countdown of what to book and when, with links and deadlines.

### Step 3s: Build 17-communication-cards.md
Read `references/communication-templates.md`. Use `assets/templates/printable-cards.md`.
Generate all taxi cards, allergy cards, emergency cards, phrase cards in local language.

### Step 3t: Build 18-companion-briefing.md
Use `assets/templates/companion-briefing.md`.
Generate shareable one-pager for all travel companions with trip summary,
key dates, meeting points, emergency contacts, and packing reminders.

### Step 3u: Build 19-post-trip.md
Read `references/post-trip-lifecycle.md`.
Generate jet lag recovery plan, expense template, customs guide, review reminders,
loyalty points checklist, and photo organization suggestions.

### Step 3v: Set Up Digital Trip Binder
Read `references/digital-trip-binder.md`.
Include instructions for offline access, companion sharing, and phone organization.
Add paper backup recommendations and cloud sync setup.

---

## Phase 4: Review & Refine

Present the completed trip folder to the user with a summary of key highlights.
Ask: "Want me to dive deeper on any section, adjust the itinerary, or explore
alternative options for anything?"

Iterate until the user is satisfied.

---

## Quality Checklist — Nothing-Missed Verification

Before presenting the final trip folder, verify ALL of the following:

### Logistics
- [ ] Visa requirements researched and documented
- [ ] Passport validity requirements noted
- [ ] Travel insurance options provided
- [ ] Vaccination/health requirements checked
- [ ] Currency and exchange rate info included
- [ ] Tipping customs documented
- [ ] Power adapter / voltage noted
- [ ] SIM card / connectivity options listed
- [ ] Time zone difference from origin noted
- [ ] Driving side (left/right) noted if renting car

### Safety
- [ ] Government travel advisories checked
- [ ] Common scams documented
- [ ] Areas to avoid noted
- [ ] Emergency numbers listed (police, ambulance, embassy)
- [ ] Travel insurance recommendation included
- [ ] Nearest hospital to each accommodation noted

### Practical
- [ ] Airport transfer options for arrival/departure
- [ ] Luggage storage options if needed
- [ ] Laundry options for longer trips
- [ ] Pharmacy / medical supply locations
- [ ] ATM availability and fee notes
- [ ] Credit card acceptance levels
- [ ] Public toilet locations / customs

### Cultural
- [ ] Dress code guidance (temples, restaurants, beaches)
- [ ] Photo etiquette (ask before photographing people)
- [ ] Religious customs and sensitivities
- [ ] Business hours / siesta culture
- [ ] Local holidays during trip dates
- [ ] Basic phrases in local language

### Weather & Packing
- [ ] Historical weather data for trip dates
- [ ] Layering advice
- [ ] Rain gear if needed
- [ ] Sun protection level
- [ ] Specific activity gear (hiking boots, snorkel, etc.)
- [ ] Formal wear if needed for restaurants/events

### Maps & Navigation
- [ ] Every location has a Google Maps link
- [ ] Every location has an Apple Maps link
- [ ] Every transit between activities has step-by-step directions
- [ ] Day routes are generated as multi-stop Google Maps links
- [ ] Offline map download instructions included
- [ ] Key addresses saved in local script for taxi drivers

### Alternatives
- [ ] Every restaurant has a backup recommendation
- [ ] Every activity has a rainy-day alternative
- [ ] Every day has a complete Plan B
- [ ] Transport contingencies documented
- [ ] Emergency contacts and procedures included

### Visual References
- [ ] Key locations have photo/video references
- [ ] Sunrise/sunset times documented
- [ ] Photography spots identified and timed
- [ ] YouTube walkthrough links where available

### Booking Intelligence
- [ ] Every flight has a "book by" recommendation
- [ ] Every hotel has cancellation policy noted
- [ ] Activities sorted by booking urgency
- [ ] Booking timeline countdown generated
- [ ] Price monitoring tools recommended

### Communication Readiness
- [ ] Taxi destination cards generated in local script
- [ ] Allergy/dietary card generated in local script
- [ ] Emergency card with personal details generated
- [ ] Restaurant phrase card generated
- [ ] Hotel request card generated

### Post-Trip
- [ ] Jet lag recovery plan customized to route
- [ ] Expense reconciliation template pre-filled with budget
- [ ] Customs/duty guidance for return country
- [ ] Review links pre-populated for key venues
- [ ] Loyalty points checklist generated

### Trip Binder
- [ ] Offline access instructions included
- [ ] Companion sharing instructions included
- [ ] Phone file organization guide included
- [ ] Paper backup recommendations included

### Seasonal Awareness
- [ ] All events/festivals during trip dates documented
- [ ] Public holidays and closures identified
- [ ] Seasonal weather patterns noted
- [ ] School holiday crowd impact assessed
- [ ] Seasonal food/nature highlights flagged

### Multi-City (If Applicable)
- [ ] Route optimized for minimum backtracking
- [ ] Distance/time matrix generated
- [ ] Hub-and-spoke vs linear analysis done
- [ ] Open-jaw flight option evaluated
- [ ] Border crossing logistics documented (multi-country)

### Packing Optimization
- [ ] Weight budget calculated against airline limits
- [ ] Capsule wardrobe color-coordinated
- [ ] Laundry plan included for trips over 1 week
- [ ] Activity-specific gear listed
- [ ] Souvenir weight buffer calculated

### Insurance
- [ ] Insurance recommendation with coverage comparison
- [ ] Pre-trip photo documentation reminder
- [ ] Incident documentation checklist included
- [ ] Claim filing steps documented
- [ ] Emergency contact numbers in insurance section

### Cultural Intelligence
- [ ] Top 80 phrases compiled with pronunciation guide
- [ ] Do's and don'ts researched from local AND tourist sources
- [ ] "Big 5" most important cultural rules highlighted
- [ ] Quick reference card included
- [ ] Real traveler "wish I knew" insights included

### Advanced Domains
- [ ] Relevant advanced domain checklists incorporated
- [ ] Domain-specific accommodations/activities researched
- [ ] Special requirements noted in checklists
