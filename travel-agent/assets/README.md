# Travel Agent — Assets

## Folder Structure

```
assets/
├── README.md                        # This file — conventions & index
├── templates/                       # Reusable output templates
│   ├── README.md                    # Template index with descriptions
│   ├── itinerary-template.md        # Day-by-day itinerary format
│   ├── comparison-table.md          # Side-by-side comparison format
│   ├── country-guide-template.md    # Country/region guide format
│   ├── packing-list-base.md         # Climate-adaptive packing format
│   ├── step-by-step-guide.md        # Walking/transit direction format
│   ├── daily-pocket-card.md         # Phone-friendly daily quick ref
│   └── trip-summary-card.md         # One-page trip overview card
```

## Naming Conventions

| Convention | Rule | Example |
|---|---|---|
| File names | lowercase-kebab-case | `country-guide-template.md` |
| Template files | `*-template.md` suffix | `itinerary-template.md` |
| Base/starter files | `*-base.md` suffix | `packing-list-base.md` |
| Output trip files | `NN-descriptive-name.md` | `01-itinerary.md` |
| Numbering | 2-digit prefix for ordering | `00-` through `15-` |

## Trip Output Folder Structure

When `scripts/init-trip.sh` runs, it creates:

```
trips/<trip-name>/
├── 00-overview.md              # Trip summary with links to all files
├── 01-itinerary.md             # Day-by-day schedule
├── 02-country-guide.md         # Culture, customs, language, safety
├── 03-accommodations.md        # Options across budget tiers
├── 04-transport.md             # Flights, trains, local transit
├── 05-food-guide.md            # Restaurants, street food, dietary
├── 06-hidden-gems.md           # Local-language sourced discoveries
├── 07-activities.md            # Tours, experiences, day trips
├── 08-budget.md                # Three-tier cost breakdown
├── 09-checklists.md            # Pre-trip, packing, documents, health
├── 10-bookings.md              # Links, comparisons, action items
├── 11-plan-b.md                # Alternatives, rainy day, contingencies
├── 12-pocket-guide.md          # Phone-friendly daily quick reference
├── 13-maps-and-routes.md       # Google/Apple Maps links, directions
├── 14-photo-guide.md           # Visual references, photo spots, timing
├── 15-step-by-step-guides.md   # Detailed navigation between activities
└── _index.md                   # Auto-generated index with file sizes
```

## Cross-Linking Convention

All trip files cross-reference each other using relative links:
- `[See Budget](./08-budget.md#flights)` — link to specific section
- `[Map Route](./13-maps-and-routes.md#day-1)` — link to day's routes
- `[Plan B](./11-plan-b.md#day-3)` — link to day-specific alternatives

## Template Variables

Templates use `[PLACEHOLDER]` syntax for values to be filled:
- `[Trip Name]`, `[Destination]`, `[Dates]` — trip metadata
- `[Name]`, `[Location]`, `[Cost]` — per-item details
- `$X` — price placeholder
- `[X.X]` — rating placeholder
