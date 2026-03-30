# Accommodation Analysis Methodology

## Research Protocol

### Sources to Search (ALL of these, every time)

1. **Booking.com** — Search "[city] hotels" and "[city] apartments"
   - Sort by: Guest Rating, then by Price
   - Filter by: Trip dates, number of guests, star rating per tier
   - Note: Genius discounts, free cancellation policies
   - WebSearch: `site:booking.com "[city]" [check-in] [check-out]`

2. **Airbnb** — Search "[city]" with dates
   - Filter by: Superhost, rating 4.8+, entire place vs. private room
   - Note: Cleaning fees (often hidden until checkout)
   - Check: Host response rate, cancellation policy, house rules
   - WebSearch: `site:airbnb.com "[city]" [type-of-stay]`

3. **Hostelworld** — For budget tier
   - Sort by: Rating
   - Check: Private rooms vs dorms, social atmosphere rating
   - Note: Breakfast included? Lockers? Kitchen?

4. **Boutique/Luxury Aggregators**
   - Mr & Mrs Smith (boutique)
   - Small Luxury Hotels of the World
   - Design Hotels
   - Aman, Six Senses, Four Seasons (ultra-luxury direct)

5. **Local/Specialty** (varies by destination)
   - Japan: Booking ryokans via Japanican, Japanese Guesthouses
   - Southeast Asia: Agoda (strong Asia inventory)
   - Europe: Paradores (Spain), Pousadas (Portugal)
   - Africa: Safari lodges via expert Africa

6. **Review Cross-Reference**
   - Google Maps reviews for each shortlisted property
   - TripAdvisor reviews (sort by recent)
   - Reddit: "r/[destination] hotel recommendation"

### Evaluation Criteria Per Property

| Criterion | What to Check |
|---|---|
| Location | Walking distance to key sights, transit, safety of neighborhood |
| Price | Total cost including taxes, fees, cleaning, resort fees |
| Reviews | Recent reviews (last 6 months), filter for similar traveler type |
| Cancellation | Free cancellation deadline, refund policy |
| Amenities | WiFi, AC/heat, kitchen, laundry, pool, gym, workspace |
| Unique factor | View, architecture, history, experience (treehouse, overwater, etc.) |
| Transport | Airport transfer offered? Parking? Near metro/bus? |
| Dining | Breakfast included? Restaurant on-site? Kitchen for self-catering? |
| Safety | In-room safe, 24hr reception, door locks, neighborhood safety |

### Output Structure

Present **3 options per tier** (Budget / Mid / Luxury), each with:

```
### [Property Name] — $X/night ([Tier])
**Type:** Hotel / Airbnb / Hostel / Boutique / Ryokan
**Location:** [Neighborhood], [distance to center/key sights]
**Rating:** [X.X/10 Booking] / [X.X/5 Airbnb] / [X.X/5 Google]
**Why this one:** [2 sentences on what makes it stand out]
**Watch out for:** [1 sentence on any downsides]
**Book at:** [Direct link]
**Cancellation:** [Policy summary]
**Price breakdown:**
- Nightly rate: $X
- Taxes/fees: $X
- Cleaning fee: $X (Airbnb)
- Total for stay: $X
```

### Comparison Table

Always include a summary comparison table:

| Property | Tier | $/Night | Rating | Location | Cancel | Unique |
|---|---|---|---|---|---|---|
| Name 1 | Budget | $50 | 8.5 | Old Town, 5min walk | Free 48h | Rooftop terrace |
| Name 2 | Mid | $120 | 9.1 | Riverside, 10min metro | Free 24h | River view rooms |
| Name 3 | Luxury | $350 | 9.6 | City center | Non-refund | Michelin restaurant |

### Area Recommendation

Include a neighborhood analysis:
- **Where to stay for first-timers:** [Neighborhood] — why
- **Where to stay for foodies:** [Neighborhood] — why
- **Where to stay for nightlife:** [Neighborhood] — why
- **Where to stay for families:** [Neighborhood] — why
- **Where to stay for budget:** [Neighborhood] — why
- **Where to stay for luxury:** [Neighborhood] — why
- **Where to avoid:** [Neighborhood] — why (safety, noise, distance)
