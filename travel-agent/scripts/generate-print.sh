#!/usr/bin/env bash
# Usage: generate-print.sh <trip-folder>
# Generates print-optimized HTML for select deliverables:
#   - Communication cards (wallet-sized, 4-up on A4)
#   - Pocket guide (foldable)
#   - Checklists (with checkbox squares)
#   - Companion briefing (single page)
#   - Itinerary, budget, booking timeline, country guide, transport, step-by-step
# Also generates shareable assets in share/.
# No external dependencies.

set -euo pipefail

TRIP_DIR="${1:?Usage: generate-print.sh <trip-folder-path>}"

if [ ! -d "$TRIP_DIR" ]; then
  echo "Error: Trip folder not found: $TRIP_DIR"
  exit 1
fi

TRIP_NAME="$(basename "$TRIP_DIR")"

mkdir -p "$TRIP_DIR/print"
mkdir -p "$TRIP_DIR/share"

# --- Shared CSS for print files ---
PRINT_CSS='
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
                 "Helvetica Neue", Arial, sans-serif;
    font-size: 11pt;
    line-height: 1.5;
    color: #000;
    background: #fff;
    padding: 0.5in;
  }
  h1 { font-size: 16pt; margin: 0 0 8pt; }
  h2 { font-size: 13pt; margin: 16pt 0 6pt; border-bottom: 1pt solid #ccc; padding-bottom: 3pt; }
  h3 { font-size: 11pt; margin: 12pt 0 4pt; }
  p { margin: 0 0 6pt; }
  ul, ol { margin: 0 0 8pt; padding-left: 18pt; }
  li { margin-bottom: 2pt; }
  table { width: 100%; border-collapse: collapse; margin: 0 0 8pt; font-size: 9pt; }
  th, td { border: 1px solid #ccc; padding: 4pt 6pt; text-align: left; }
  th { background: #f0f0f0; font-weight: 600; }
  a { color: #000; text-decoration: underline; }
  hr { border: none; border-top: 1px solid #ccc; margin: 12pt 0; }
  blockquote { border-left: 2pt solid #999; padding-left: 8pt; color: #555; margin: 0 0 8pt; }
  code { font-family: Menlo, Consolas, monospace; font-size: 9pt; background: #f5f5f5; padding: 1pt 3pt; }
  .page-break { page-break-after: always; }
  @media print {
    body { padding: 0; }
    .no-print { display: none !important; }
  }
</style>
'

# --- Reusable: basic markdown to HTML (simplified for print) ---
md_to_print_html() {
  local mdfile="$1"
  local in_code=0

  while IFS= read -r line || [ -n "$line" ]; do
    # Code blocks
    if echo "$line" | grep -q '^```'; then
      if [ "$in_code" -eq 1 ]; then
        echo '</code></pre>'
        in_code=0
      else
        echo '<pre><code>'
        in_code=1
      fi
      continue
    fi
    if [ "$in_code" -eq 1 ]; then
      echo "$line" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
      continue
    fi

    # Empty lines
    [ -z "$line" ] && continue

    # Horizontal rules
    if echo "$line" | grep -qE '^-{3,}$|^\*{3,}$'; then
      echo '<hr>'
      continue
    fi

    # Headings
    if echo "$line" | grep -q '^#### '; then
      echo "<h4>${line#*#### }</h4>"; continue
    fi
    if echo "$line" | grep -q '^### '; then
      echo "<h3>${line#*### }</h3>"; continue
    fi
    if echo "$line" | grep -q '^## '; then
      echo "<h2>${line#*## }</h2>"; continue
    fi
    if echo "$line" | grep -q '^# '; then
      echo "<h1>${line#*# }</h1>"; continue
    fi

    # Blockquotes
    if echo "$line" | grep -q '^> '; then
      echo "<blockquote><p>${line#> }</p></blockquote>"; continue
    fi

    # Tables
    if echo "$line" | grep -q '^|'; then
      if echo "$line" | grep -qE '^\|[[:space:]:|-]+\|$'; then continue; fi
      echo '<tr>'
      echo "$line" | sed 's/^|//; s/|$//' | awk -F'|' '{ for(i=1;i<=NF;i++) { gsub(/^[ \t]+|[ \t]+$/, "", $i); printf "<td>%s</td>", $i } }'
      echo '</tr>'
      continue
    fi

    # Checkbox items -> print squares
    if echo "$line" | grep -qE '^\s*[-*+] \[[ xX]\] '; then
      local checked="&#9744;"
      if echo "$line" | grep -qE '^\s*[-*+] \[[xX]\] '; then checked="&#9745;"; fi
      local text
      text="$(echo "$line" | sed 's/^\s*[-*+] \[[ xX]\] //')"
      echo "<p style=\"margin:2pt 0;\">${checked} ${text}</p>"
      continue
    fi

    # List items
    if echo "$line" | grep -qE '^\s*[-*+] '; then
      local text="${line#*- }"
      text="${text#*\* }"
      text="${text#*+ }"
      echo "<li>$text</li>"
      continue
    fi
    if echo "$line" | grep -qE '^\s*[0-9]+\. '; then
      local text
      text="$(echo "$line" | sed 's/^\s*[0-9]*\. //')"
      echo "<li>$text</li>"
      continue
    fi

    # Inline formatting then paragraph
    line="$(echo "$line" | sed -E '
      s/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g
      s/\*([^*]+)\*/<em>\1<\/em>/g
      s/`([^`]+)`/<code>\1<\/code>/g
      s/\[([^]]+)\]\(([^)]+)\)/<a href="\2">\1<\/a>/g
    ')"
    echo "<p>$line</p>"

  done < "$mdfile"
  if [ "$in_code" -eq 1 ]; then echo '</code></pre>'; fi
}

# ============================================================
# 1. COMMUNICATION CARDS — wallet-sized, 4-up on A4
# ============================================================
generate_communication_cards() {
  local src="$TRIP_DIR/17-communication-cards.md"
  local out="$TRIP_DIR/print/communication-cards.html"

  echo "  Generating: print/communication-cards.html"

  cat > "$out" << 'CARDHTML'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Communication Cards</title>
<style>
  @page { size: A4; margin: 0.4in; }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 9pt;
    line-height: 1.4;
    color: #000;
  }
  .card-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.2in;
    padding: 0.1in;
  }
  .card {
    border: 1.5pt solid #000;
    border-radius: 6pt;
    padding: 10pt 12pt;
    min-height: 2.5in;
    max-height: 3.4in;
    overflow: hidden;
    page-break-inside: avoid;
  }
  .card h3 {
    font-size: 10pt;
    margin-bottom: 6pt;
    border-bottom: 1pt solid #ccc;
    padding-bottom: 3pt;
    text-transform: uppercase;
    letter-spacing: 0.5pt;
  }
  .card p, .card li { font-size: 9pt; margin-bottom: 2pt; }
  .card ul { padding-left: 14pt; }
  .card .label { font-weight: 600; }
  .card .big-text { font-size: 12pt; font-weight: 700; }
  .cut-line { border-top: 1px dashed #aaa; margin: 0.15in 0; }
  h1 { text-align: center; font-size: 14pt; margin: 0.2in 0; }
  .instructions {
    text-align: center; font-size: 8pt; color: #777;
    margin-bottom: 0.15in;
  }
  @media print {
    .instructions { display: none; }
  }
</style>
</head>
<body>
<h1>Communication Cards</h1>
<p class="instructions">Print on A4, cut along card borders. Cards fit in a wallet or passport holder.</p>
<div class="card-grid">
CARDHTML

  # Parse the markdown to extract card sections, or generate placeholder cards
  if [ -f "$src" ] && [ -s "$src" ]; then
    # Extract content sections separated by h2/h3 headings
    local current_title=""
    local current_body=""
    while IFS= read -r line || [ -n "$line" ]; do
      if echo "$line" | grep -qE '^#{2,3} '; then
        # Flush previous card
        if [ -n "$current_title" ]; then
          echo "<div class=\"card\"><h3>${current_title}</h3>${current_body}</div>" >> "$out"
          current_body=""
        fi
        current_title="$(echo "$line" | sed 's/^#* //')"
      elif [ -n "$line" ] && [ -n "$current_title" ]; then
        # Inline format
        local formatted
        formatted="$(echo "$line" | sed -E '
          s/\*\*([^*]+)\*\*/<span class="label">\1<\/span>/g
          s/\*([^*]+)\*/<em>\1<\/em>/g
          s/`([^`]+)`/<code>\1<\/code>/g
        ')"
        # Handle list items
        if echo "$line" | grep -qE '^\s*[-*] '; then
          formatted="$(echo "$formatted" | sed 's/^\s*[-*] //')"
          current_body="${current_body}<p style=\"margin:1pt 0;\">• ${formatted}</p>"
        else
          current_body="${current_body}<p>${formatted}</p>"
        fi
      fi
    done < "$src"
    # Flush last card
    if [ -n "$current_title" ]; then
      echo "<div class=\"card\"><h3>${current_title}</h3>${current_body}</div>" >> "$out"
    fi
  else
    # Generate placeholder cards
    cat >> "$out" << 'PLACEHOLDER'
  <div class="card">
    <h3>Emergency Card</h3>
    <p class="big-text">EMERGENCY</p>
    <p><span class="label">Name:</span> _______________</p>
    <p><span class="label">Hotel:</span> _______________</p>
    <p><span class="label">Embassy:</span> _______________</p>
    <p><span class="label">Emergency:</span> _______________</p>
    <p><span class="label">Insurance:</span> _______________</p>
  </div>
  <div class="card">
    <h3>Taxi Destination Card</h3>
    <p class="big-text">TAXI</p>
    <p>Please take me to:</p>
    <p><span class="label">Hotel:</span> _______________</p>
    <p><span class="label">Address:</span> _______________</p>
    <p style="font-size:8pt;color:#777;">Show this card to taxi driver</p>
  </div>
  <div class="card">
    <h3>Allergy / Dietary Card</h3>
    <p class="big-text">FOOD ALLERGY</p>
    <p>I cannot eat:</p>
    <p>_______________</p>
    <p>_______________</p>
    <p style="font-size:8pt;color:#777;">Show this card at restaurants</p>
  </div>
  <div class="card">
    <h3>Key Phrases Card</h3>
    <p><span class="label">Hello:</span> _______________</p>
    <p><span class="label">Thank you:</span> _______________</p>
    <p><span class="label">Please:</span> _______________</p>
    <p><span class="label">Help:</span> _______________</p>
    <p><span class="label">Where is...:</span> _______________</p>
    <p><span class="label">How much:</span> _______________</p>
  </div>
PLACEHOLDER
  fi

  cat >> "$out" << 'CARDEND'
</div>
</body>
</html>
CARDEND
}

# ============================================================
# 2. POCKET GUIDE — foldable design
# ============================================================
generate_pocket_guide() {
  local src="$TRIP_DIR/12-pocket-guide.md"
  local out="$TRIP_DIR/print/pocket-guide.html"

  echo "  Generating: print/pocket-guide.html"

  cat > "$out" << POCKETHEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${TRIP_NAME} — Pocket Guide</title>
<style>
  @page { size: A4; margin: 0.3in; }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 8pt;
    line-height: 1.35;
    color: #000;
  }
  .pocket-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.15in;
  }
  .pocket-section {
    border: 1pt solid #ccc;
    border-radius: 4pt;
    padding: 8pt;
    page-break-inside: avoid;
  }
  .pocket-section h2 {
    font-size: 9pt;
    margin-bottom: 4pt;
    border-bottom: 0.5pt solid #ddd;
    padding-bottom: 2pt;
    text-transform: uppercase;
    letter-spacing: 0.3pt;
  }
  .pocket-section h3 { font-size: 8pt; margin: 4pt 0 2pt; }
  .pocket-section p { margin-bottom: 2pt; }
  .pocket-section ul { padding-left: 12pt; margin-bottom: 3pt; }
  .pocket-section li { margin-bottom: 1pt; }
  .pocket-section table { font-size: 7pt; width: 100%; border-collapse: collapse; }
  .pocket-section th, .pocket-section td { border: 0.5pt solid #ddd; padding: 2pt 4pt; }
  .pocket-section th { background: #f5f5f5; }
  strong { font-weight: 700; }
  .fold-line {
    border-top: 1px dashed #bbb;
    margin: 0.1in 0;
    position: relative;
  }
  .fold-line::after {
    content: "fold here";
    position: absolute;
    top: -7pt;
    left: 50%;
    transform: translateX(-50%);
    background: #fff;
    padding: 0 4pt;
    font-size: 6pt;
    color: #bbb;
  }
  h1 {
    text-align: center;
    font-size: 12pt;
    margin: 0.1in 0;
  }
  .subtitle {
    text-align: center;
    font-size: 7pt;
    color: #999;
    margin-bottom: 0.1in;
  }
  @media print { .subtitle { color: #999; } }
</style>
</head>
<body>
<h1>${TRIP_NAME} — Pocket Guide</h1>
<p class="subtitle">Print on A4, fold into quarters for pocket carry</p>
<div class="fold-line"></div>
<div class="pocket-grid">
POCKETHEAD

  if [ -f "$src" ] && [ -s "$src" ]; then
    # Parse sections from the markdown
    local current_section=""
    local section_content=""
    while IFS= read -r line || [ -n "$line" ]; do
      if echo "$line" | grep -qE '^## '; then
        if [ -n "$current_section" ]; then
          echo "<div class=\"pocket-section\"><h2>${current_section}</h2>${section_content}</div>" >> "$out"
          section_content=""
        fi
        current_section="$(echo "$line" | sed 's/^## //')"
      elif echo "$line" | grep -q '^### '; then
        section_content="${section_content}<h3>$(echo "$line" | sed 's/^### //')</h3>"
      elif echo "$line" | grep -qE '^\s*[-*] '; then
        local item
        item="$(echo "$line" | sed 's/^\s*[-*] //')"
        item="$(echo "$item" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')"
        section_content="${section_content}<p style=\"margin:1pt 0;\">• ${item}</p>"
      elif [ -n "$line" ] && ! echo "$line" | grep -q '^# '; then
        local formatted
        formatted="$(echo "$line" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')"
        section_content="${section_content}<p>${formatted}</p>"
      fi
    done < "$src"
    if [ -n "$current_section" ]; then
      echo "<div class=\"pocket-section\"><h2>${current_section}</h2>${section_content}</div>" >> "$out"
    fi
  else
    cat >> "$out" << 'POCKETPLACEHOLDER'
  <div class="pocket-section">
    <h2>Emergency Numbers</h2>
    <p><strong>Police:</strong> ___</p>
    <p><strong>Ambulance:</strong> ___</p>
    <p><strong>Embassy:</strong> ___</p>
    <p><strong>Hotel:</strong> ___</p>
  </div>
  <div class="pocket-section">
    <h2>Key Addresses</h2>
    <p><strong>Hotel:</strong> ___</p>
    <p><strong>Airport:</strong> ___</p>
  </div>
  <div class="pocket-section">
    <h2>Essential Phrases</h2>
    <p><strong>Hello:</strong> ___</p>
    <p><strong>Thank you:</strong> ___</p>
    <p><strong>Where is...:</strong> ___</p>
    <p><strong>How much:</strong> ___</p>
  </div>
  <div class="pocket-section">
    <h2>Daily Reminders</h2>
    <p>• Currency: ___</p>
    <p>• Tipping: ___</p>
    <p>• Voltage: ___</p>
    <p>• Time zone: ___</p>
  </div>
POCKETPLACEHOLDER
  fi

  cat >> "$out" << 'POCKETEND'
</div>
</body>
</html>
POCKETEND
}

# ============================================================
# 3. CHECKLISTS — with empty checkbox squares for pen
# ============================================================
generate_checklists() {
  local src="$TRIP_DIR/09-checklists.md"
  local out="$TRIP_DIR/print/checklists.html"

  echo "  Generating: print/checklists.html"

  cat > "$out" << CHECKHEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${TRIP_NAME} — Checklists</title>
${PRINT_CSS}
<style>
  .checkbox-item {
    margin: 3pt 0;
    padding-left: 22pt;
    position: relative;
    line-height: 1.6;
  }
  .checkbox-item::before {
    content: "";
    position: absolute;
    left: 0;
    top: 2pt;
    width: 12pt;
    height: 12pt;
    border: 1.5pt solid #000;
    border-radius: 2pt;
  }
  h2 { page-break-after: avoid; }
  .checklist-section { page-break-inside: avoid; margin-bottom: 12pt; }
</style>
</head>
<body>
<h1>${TRIP_NAME} — Checklists</h1>
<p style="color:#777;font-size:9pt;margin-bottom:12pt;">Print and check off with a pen as you go.</p>
CHECKHEAD

  if [ -f "$src" ] && [ -s "$src" ]; then
    local in_section=0
    while IFS= read -r line || [ -n "$line" ]; do
      [ -z "$line" ] && continue

      if echo "$line" | grep -q '^## '; then
        if [ "$in_section" -eq 1 ]; then echo '</div>' >> "$out"; fi
        echo "<div class=\"checklist-section\"><h2>$(echo "$line" | sed 's/^## //')</h2>" >> "$out"
        in_section=1
      elif echo "$line" | grep -q '^### '; then
        echo "<h3>$(echo "$line" | sed 's/^### //')</h3>" >> "$out"
      elif echo "$line" | grep -qE '^\s*[-*+] \[[ xX]\] '; then
        local text
        text="$(echo "$line" | sed 's/^\s*[-*+] \[[ xX]\] //')"
        text="$(echo "$text" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')"
        echo "<div class=\"checkbox-item\">${text}</div>" >> "$out"
      elif echo "$line" | grep -qE '^\s*[-*+] '; then
        local text
        text="$(echo "$line" | sed 's/^\s*[-*+] //')"
        text="$(echo "$text" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')"
        echo "<div class=\"checkbox-item\">${text}</div>" >> "$out"
      elif echo "$line" | grep -q '^# '; then
        : # skip title
      else
        local formatted
        formatted="$(echo "$line" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')"
        echo "<p>${formatted}</p>" >> "$out"
      fi
    done < "$src"
    if [ "$in_section" -eq 1 ]; then echo '</div>' >> "$out"; fi
  else
    cat >> "$out" << 'CHECKPLACEHOLDER'
<div class="checklist-section">
  <h2>Pre-Trip</h2>
  <div class="checkbox-item">Passport valid for 6+ months</div>
  <div class="checkbox-item">Visa arranged (if needed)</div>
  <div class="checkbox-item">Travel insurance purchased</div>
  <div class="checkbox-item">Accommodation booked</div>
  <div class="checkbox-item">Flights booked</div>
  <div class="checkbox-item">Bank notified of travel</div>
</div>
<div class="checklist-section">
  <h2>Packing</h2>
  <div class="checkbox-item">Passport & copies</div>
  <div class="checkbox-item">Phone charger & adapter</div>
  <div class="checkbox-item">Medications</div>
  <div class="checkbox-item">Toiletries</div>
  <div class="checkbox-item">Weather-appropriate clothing</div>
</div>
CHECKPLACEHOLDER
  fi

  echo '</body></html>' >> "$out"
}

# ============================================================
# 4. COMPANION BRIEFING — single-page shareable
# ============================================================
generate_companion_briefing() {
  local src="$TRIP_DIR/18-companion-briefing.md"
  local out="$TRIP_DIR/print/companion-briefing.html"
  local share_out="$TRIP_DIR/share/companion-briefing.html"

  echo "  Generating: print/companion-briefing.html"
  echo "  Generating: share/companion-briefing.html"

  local body_content=""
  if [ -f "$src" ] && [ -s "$src" ]; then
    body_content="$(md_to_print_html "$src")"
  else
    body_content='<h1>Companion Briefing</h1>
<p><em>This briefing will be populated after trip planning is complete.</em></p>
<h2>Trip Summary</h2>
<p><strong>Destination:</strong> ___</p>
<p><strong>Dates:</strong> ___</p>
<p><strong>Duration:</strong> ___</p>
<h2>Key Information</h2>
<p><strong>Hotel:</strong> ___</p>
<p><strong>Emergency Contact:</strong> ___</p>
<p><strong>Flight Details:</strong> ___</p>'
  fi

  # Print version (optimized for single page)
  cat > "$out" << COMPHEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${TRIP_NAME} — Companion Briefing</title>
${PRINT_CSS}
<style>
  body { font-size: 10pt; padding: 0.4in; }
  h1 { font-size: 14pt; text-align: center; }
  @page { size: A4; margin: 0.4in; }
</style>
</head>
<body>
${body_content}
</body>
</html>
COMPHEAD

  # Shareable version (self-contained, email-friendly)
  cat > "$share_out" << SHAREHEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${TRIP_NAME} — Companion Briefing</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 15px;
    line-height: 1.6;
    color: #1a1a1a;
    background: #fff;
    max-width: 600px;
    margin: 0 auto;
    padding: 24px 16px;
  }
  h1 { font-size: 22px; margin: 0 0 16px; text-align: center; }
  h2 { font-size: 17px; margin: 20px 0 8px; border-bottom: 1px solid #e0e0e0; padding-bottom: 4px; }
  h3 { font-size: 15px; margin: 16px 0 6px; }
  p { margin: 0 0 8px; }
  ul, ol { margin: 0 0 10px; padding-left: 20px; }
  li { margin-bottom: 4px; }
  strong { font-weight: 600; }
  a { color: #2563eb; }
  table { width: 100%; border-collapse: collapse; margin: 0 0 10px; font-size: 14px; }
  th, td { border: 1px solid #e0e0e0; padding: 6px 8px; text-align: left; }
  th { background: #f8f9fa; }
  blockquote { border-left: 3px solid #2563eb; padding-left: 12px; color: #555; margin: 0 0 10px; }
  hr { border: none; border-top: 1px solid #e0e0e0; margin: 16px 0; }
  .footer { text-align: center; color: #999; font-size: 12px; margin-top: 32px; }
  @media (prefers-color-scheme: dark) {
    body { background: #0f0f0f; color: #e8e8e8; }
    h2 { border-bottom-color: #333; }
    th { background: #1a1a1a; }
    th, td { border-color: #333; }
    blockquote { color: #aaa; }
  }
</style>
</head>
<body>
${body_content}
<div class="footer">Shared from /travel-agent trip planner</div>
</body>
</html>
SHAREHEAD
}

# ============================================================
# 5. GENERIC PRINT — itinerary, budget, timeline, etc.
# ============================================================
generate_generic_print() {
  local src="$1"
  local out="$2"
  local title="$3"

  if [ ! -f "$src" ] || [ ! -s "$src" ]; then
    return
  fi

  echo "  Generating: $out"

  local body_content
  body_content="$(md_to_print_html "$src")"

  cat > "$TRIP_DIR/$out" << GENHEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${TRIP_NAME} — ${title}</title>
${PRINT_CSS}
</head>
<body>
${body_content}
</body>
</html>
GENHEAD
}

# ============================================================
# 6. TRIP SUMMARY — shareable overview
# ============================================================
generate_trip_summary() {
  local src="$TRIP_DIR/00-overview.md"
  local out="$TRIP_DIR/share/trip-summary.html"

  echo "  Generating: share/trip-summary.html"

  local body_content=""
  if [ -f "$src" ] && [ -s "$src" ]; then
    body_content="$(md_to_print_html "$src")"
  else
    body_content="<h1>${TRIP_NAME}</h1><p><em>Trip overview will be populated after planning.</em></p>"
  fi

  cat > "$out" << SUMMARYHEAD
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${TRIP_NAME} — Trip Summary</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 15px;
    line-height: 1.6;
    color: #1a1a1a;
    background: #fff;
    max-width: 600px;
    margin: 0 auto;
    padding: 24px 16px;
  }
  h1 { font-size: 22px; margin: 0 0 12px; }
  h2 { font-size: 17px; margin: 20px 0 8px; border-bottom: 1px solid #e0e0e0; padding-bottom: 4px; }
  p { margin: 0 0 8px; }
  ul { margin: 0 0 10px; padding-left: 20px; }
  li { margin-bottom: 4px; }
  a { color: #2563eb; }
  strong { font-weight: 600; }
  hr { border: none; border-top: 1px solid #e0e0e0; margin: 16px 0; }
  .footer { text-align: center; color: #999; font-size: 12px; margin-top: 32px; }
  @media (prefers-color-scheme: dark) {
    body { background: #0f0f0f; color: #e8e8e8; }
    h2 { border-bottom-color: #333; }
  }
</style>
</head>
<body>
${body_content}
<div class="footer">Shared from /travel-agent trip planner</div>
</body>
</html>
SUMMARYHEAD
}

# ============================================================
# MAIN
# ============================================================
echo "Generating print & share files for: $TRIP_NAME"
echo ""

# Print-specific formats
generate_communication_cards
generate_pocket_guide
generate_checklists
generate_companion_briefing

# Generic print versions for files that need PDF/print
generate_generic_print "$TRIP_DIR/01-itinerary.md" "print/itinerary.html" "Itinerary"
generate_generic_print "$TRIP_DIR/02-country-guide.md" "print/country-guide.html" "Country Guide"
generate_generic_print "$TRIP_DIR/04-transport.md" "print/transport.html" "Transport"
generate_generic_print "$TRIP_DIR/08-budget.md" "print/budget.html" "Budget"
generate_generic_print "$TRIP_DIR/15-step-by-step-guides.md" "print/step-by-step-guides.html" "Step-by-Step Guides"
generate_generic_print "$TRIP_DIR/16-booking-timeline.md" "print/booking-timeline.html" "Booking Timeline"

# Shareable assets
generate_trip_summary

echo ""
# Count outputs
print_count=$(find "$TRIP_DIR/print" -name "*.html" 2>/dev/null | wc -l | tr -d ' ')
share_count=$(find "$TRIP_DIR/share" -name "*.html" 2>/dev/null | wc -l | tr -d ' ')
echo "Done! Generated:"
echo "  ${print_count} print-ready files in print/"
echo "  ${share_count} shareable files in share/"
echo ""
echo "To print: Open any file in print/ and press Cmd+P (or Ctrl+P)"
echo "To share: Email or AirDrop files from share/"
