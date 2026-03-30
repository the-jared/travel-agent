# Output Formats Guide

## Format Strategy

Markdown is the authoring format. After writing all .md files, generate
consumer-ready versions in multiple formats.

### Format Matrix

| Deliverable | MD | HTML | PDF | Why |
|---|---|---|---|---|
| 00-overview | ✓ | ✓ (landing page) | — | HTML = clickable hub with links to all files |
| 01-itinerary | ✓ | ✓ (mobile-friendly) | ✓ | Print for carry, HTML for phone |
| 02-country-guide | ✓ | ✓ | ✓ | Print key sections, phone reference |
| 03-accommodations | ✓ | ✓ (clickable links) | — | Links need to be clickable |
| 04-transport | ✓ | ✓ (clickable links) | ✓ | Print route summary, clickable booking |
| 05-food-guide | ✓ | ✓ (with map links) | — | Clickable map links essential |
| 06-hidden-gems | ✓ | ✓ (with map links) | — | Map links essential |
| 07-activities | ✓ | ✓ | — | Clickable booking links |
| 08-budget | ✓ | ✓ | ✓ | Print for reference |
| 09-checklists | ✓ | ✓ (interactive checkboxes) | ✓ | Print to check off, HTML for interactive |
| 10-bookings | ✓ | ✓ (clickable links) | — | All links must be clickable |
| 11-plan-b | ✓ | ✓ | — | Reference on phone |
| 12-pocket-guide | ✓ | ✓ (mobile-first) | ✓ (wallet card) | THE phone/print deliverable |
| 13-maps-and-routes | ✓ | ✓ (clickable maps) | — | Maps MUST be clickable |
| 14-photo-guide | ✓ | ✓ | — | Reference |
| 15-step-by-step | ✓ | ✓ (clickable) | ✓ | Print directions as backup |
| 16-booking-timeline | ✓ | ✓ (interactive) | ✓ | Print countdown, check off online |
| 17-communication-cards | ✓ | — | ✓ (printable cards) | MUST be printable physical cards |
| 18-companion-briefing | ✓ | ✓ (shareable) | ✓ (email as PDF) | Share via email/message |
| 19-post-trip | ✓ | ✓ | — | Reference |

### HTML Features
- Mobile-responsive (viewport meta tag)
- Dark mode support
- Clickable links open in new tabs
- Interactive checkboxes for checklists
- Sticky navigation header
- Print-friendly @media print styles
- Offline-capable (all content inline, no external resources)
- Clean typography (system fonts, good line-height)

### PDF Features
- Clean, printable layout
- No wasted margins
- Communication cards: sized for wallet/passport holder
- Pocket guide: foldable A4 → pocket size
- Checklists: checkbox squares for pen marking

### Generation Methods
1. **HTML:** Write directly as .html files using a base template with embedded CSS
2. **PDF:** Generate using the `html-to-pdf` script (puppeteer/wkhtmltopdf) or by providing print-ready HTML with @media print styles that the user can Cmd+P
3. **Shareable:** HTML files that can be emailed, AirDropped, or uploaded to cloud storage

## Folder Structure

```
trips/<trip-name>/
├── *.md                   # Source markdown files (all 20)
├── html/                  # Mobile-friendly HTML versions
│   ├── index.html         # Landing page with links to all files
│   ├── itinerary.html
│   ├── food-guide.html
│   ├── pocket-guide.html  # Mobile-first design
│   ├── checklists.html    # Interactive checkboxes
│   └── ...
├── print/                 # Print-ready files
│   ├── itinerary.html     # Print-optimized (Cmd+P ready)
│   ├── checklists.html    # Checkbox squares for pen
│   ├── communication-cards.html  # Wallet-sized cards
│   ├── pocket-guide.html  # Foldable pocket card
│   ├── companion-briefing.html   # Email-ready one-pager
│   └── booking-timeline.html
└── share/                 # Shareable assets
    ├── companion-briefing.html   # Self-contained, email-ready
    └── trip-summary.html         # Quick overview for sharing
```
