#!/usr/bin/env bash
# Usage: generate-html.sh <trip-folder>
# Converts markdown files to styled, mobile-responsive HTML.
# No external dependencies — uses sed/awk only.

set -euo pipefail

TRIP_DIR="${1:?Usage: generate-html.sh <trip-folder-path>}"

if [ ! -d "$TRIP_DIR" ]; then
  echo "Error: Trip folder not found: $TRIP_DIR"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_FILE="$SKILL_DIR/assets/templates/html-base.html"

if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: HTML base template not found: $TEMPLATE_FILE"
  exit 1
fi

# Extract trip name from folder
TRIP_NAME="$(basename "$TRIP_DIR")"

# Create output directories
mkdir -p "$TRIP_DIR/html"

# File name mapping: md filename -> html display name
get_display_name() {
  local filename="$1"
  case "$filename" in
    00-overview.md)           echo "Trip Overview" ;;
    01-itinerary.md)          echo "Day-by-Day Itinerary" ;;
    02-country-guide.md)      echo "Country & Culture Guide" ;;
    03-accommodations.md)     echo "Accommodations" ;;
    04-transport.md)          echo "Transport & Getting Around" ;;
    05-food-guide.md)         echo "Food & Dining Guide" ;;
    06-hidden-gems.md)        echo "Hidden Gems" ;;
    07-activities.md)         echo "Activities & Experiences" ;;
    08-budget.md)             echo "Budget & Costs" ;;
    09-checklists.md)         echo "Checklists" ;;
    10-bookings.md)           echo "Bookings & Links" ;;
    11-plan-b.md)             echo "Plan B & Contingencies" ;;
    12-pocket-guide.md)       echo "Pocket Guide" ;;
    13-maps-and-routes.md)    echo "Maps & Routes" ;;
    14-photo-guide.md)        echo "Photo Guide" ;;
    15-step-by-step-guides.md) echo "Step-by-Step Guides" ;;
    16-booking-timeline.md)   echo "Booking Timeline" ;;
    17-communication-cards.md) echo "Communication Cards" ;;
    18-companion-briefing.md) echo "Companion Briefing" ;;
    19-post-trip.md)          echo "Post-Trip Guide" ;;
    *)                        echo "${filename%.md}" ;;
  esac
}

# Get HTML filename from markdown filename
get_html_name() {
  local filename="$1"
  # Strip leading number prefix and convert
  echo "$filename" | sed 's/^[0-9]*-//; s/\.md$/.html/; s/-guides\.html$/-guides.html/'
}

# Convert markdown to HTML body content
# This handles: headings, bold, italic, links, lists, tables, code blocks,
# blockquotes, horizontal rules, checkboxes, images
md_to_html() {
  local mdfile="$1"
  local in_code_block=0
  local in_table=0
  local in_list=0
  local list_type=""
  local in_blockquote=0
  local checkbox_id=0

  while IFS= read -r line || [ -n "$line" ]; do

    # Code blocks (fenced)
    if echo "$line" | grep -q '^```'; then
      if [ "$in_code_block" -eq 1 ]; then
        echo '</code></pre>'
        in_code_block=0
      else
        echo '<pre><code>'
        in_code_block=1
      fi
      continue
    fi

    if [ "$in_code_block" -eq 1 ]; then
      # Escape HTML inside code blocks
      echo "$line" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
      continue
    fi

    # Close list if we hit a non-list line
    if [ "$in_list" -eq 1 ]; then
      if ! echo "$line" | grep -qE '^\s*[-*+] |^\s*[0-9]+\. |^\s*$'; then
        if [ "$list_type" = "ul" ]; then
          echo '</ul>'
        else
          echo '</ol>'
        fi
        in_list=0
      fi
    fi

    # Close table if we hit a non-table line
    if [ "$in_table" -eq 1 ]; then
      if ! echo "$line" | grep -q '|'; then
        echo '</tbody></table></div>'
        in_table=0
      fi
    fi

    # Close blockquote if we hit a non-blockquote line
    if [ "$in_blockquote" -eq 1 ]; then
      if ! echo "$line" | grep -q '^> '; then
        echo '</blockquote>'
        in_blockquote=0
      fi
    fi

    # Empty lines
    if [ -z "$line" ]; then
      continue
    fi

    # Horizontal rule
    if echo "$line" | grep -qE '^-{3,}$|^\*{3,}$|^_{3,}$'; then
      echo '<hr>'
      continue
    fi

    # Headings
    if echo "$line" | grep -q '^###### '; then
      local text="${line#*###### }"
      text="$(inline_format "$text")"
      echo "<h6>$text</h6>"
      continue
    fi
    if echo "$line" | grep -q '^##### '; then
      local text="${line#*##### }"
      text="$(inline_format "$text")"
      echo "<h5>$text</h5>"
      continue
    fi
    if echo "$line" | grep -q '^#### '; then
      local text="${line#*#### }"
      text="$(inline_format "$text")"
      echo "<h4>$text</h4>"
      continue
    fi
    if echo "$line" | grep -q '^### '; then
      local text="${line#*### }"
      text="$(inline_format "$text")"
      echo "<h3>$text</h3>"
      continue
    fi
    if echo "$line" | grep -q '^## '; then
      local text="${line#*## }"
      text="$(inline_format "$text")"
      echo "<h2>$text</h2>"
      continue
    fi
    if echo "$line" | grep -q '^# '; then
      local text="${line#*# }"
      text="$(inline_format "$text")"
      echo "<h1>$text</h1>"
      continue
    fi

    # Blockquotes
    if echo "$line" | grep -q '^> '; then
      if [ "$in_blockquote" -eq 0 ]; then
        echo '<blockquote>'
        in_blockquote=1
      fi
      local text="${line#> }"
      text="$(inline_format "$text")"
      echo "<p>$text</p>"
      continue
    fi

    # Tables
    if echo "$line" | grep -q '^|'; then
      # Skip separator rows
      if echo "$line" | grep -qE '^\|[[:space:]:|-]+\|$'; then
        continue
      fi
      if [ "$in_table" -eq 0 ]; then
        echo '<div class="table-wrapper"><table>'
        echo '<thead><tr>'
        echo "$line" | sed 's/^|//; s/|$//' | awk -F'|' '{ for(i=1;i<=NF;i++) { gsub(/^[ \t]+|[ \t]+$/, "", $i); printf "<th>%s</th>", $i } }'
        echo '</tr></thead><tbody>'
        in_table=1
      else
        echo '<tr>'
        echo "$line" | sed 's/^|//; s/|$//' | awk -F'|' '{ for(i=1;i<=NF;i++) { gsub(/^[ \t]+|[ \t]+$/, "", $i); printf "<td>%s</td>", $i } }'
        echo '</tr>'
      fi
      continue
    fi

    # Checkbox list items
    if echo "$line" | grep -qE '^\s*[-*+] \[[ xX]\] '; then
      if [ "$in_list" -eq 0 ]; then
        echo '<ul style="list-style: none; padding-left: 0;">'
        in_list=1
        list_type="ul"
      fi
      checkbox_id=$((checkbox_id + 1))
      local checked=""
      if echo "$line" | grep -qE '^\s*[-*+] \[[xX]\] '; then
        checked="checked"
      fi
      local text
      text="$(echo "$line" | sed 's/^\s*[-*+] \[[ xX]\] //')"
      text="$(inline_format "$text")"
      echo "<li class=\"checklist-item\"><input type=\"checkbox\" id=\"cb${checkbox_id}\" ${checked}><label for=\"cb${checkbox_id}\">${text}</label></li>"
      continue
    fi

    # Unordered list items
    if echo "$line" | grep -qE '^\s*[-*+] '; then
      if [ "$in_list" -eq 0 ]; then
        echo '<ul>'
        in_list=1
        list_type="ul"
      fi
      local text
      text="$(echo "$line" | sed 's/^\s*[-*+] //')"
      text="$(inline_format "$text")"
      echo "<li>$text</li>"
      continue
    fi

    # Ordered list items
    if echo "$line" | grep -qE '^\s*[0-9]+\. '; then
      if [ "$in_list" -eq 0 ]; then
        echo '<ol>'
        in_list=1
        list_type="ol"
      fi
      local text
      text="$(echo "$line" | sed 's/^\s*[0-9]*\. //')"
      text="$(inline_format "$text")"
      echo "<li>$text</li>"
      continue
    fi

    # Regular paragraph
    local text
    text="$(inline_format "$line")"
    echo "<p>$text</p>"

  done < "$mdfile"

  # Close any open elements
  if [ "$in_code_block" -eq 1 ]; then echo '</code></pre>'; fi
  if [ "$in_list" -eq 1 ]; then
    if [ "$list_type" = "ul" ]; then echo '</ul>'; else echo '</ol>'; fi
  fi
  if [ "$in_table" -eq 1 ]; then echo '</tbody></table></div>'; fi
  if [ "$in_blockquote" -eq 1 ]; then echo '</blockquote>'; fi
}

# Inline formatting: bold, italic, code, links, images
inline_format() {
  local text="$1"
  # Images: ![alt](url)
  text="$(echo "$text" | sed -E 's/!\[([^]]*)\]\(([^)]+)\)/<img src="\2" alt="\1">/g')"
  # Links: [text](url)
  text="$(echo "$text" | sed -E 's/\[([^]]+)\]\(([^)]+)\)/<a href="\2" target="_blank" rel="noopener">\1<\/a>/g')"
  # Bold+italic: ***text***
  text="$(echo "$text" | sed -E 's/\*\*\*([^*]+)\*\*\*/<strong><em>\1<\/em><\/strong>/g')"
  # Bold: **text**
  text="$(echo "$text" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')"
  # Italic: *text*
  text="$(echo "$text" | sed -E 's/\*([^*]+)\*/<em>\1<\/em>/g')"
  # Inline code: `text`
  text="$(echo "$text" | sed -E 's/`([^`]+)`/<code>\1<\/code>/g')"
  echo "$text"
}

# Pre-split the template into before/after content sections for fast assembly.
# This avoids a slow per-line while-read loop for every file.
TPL_BEFORE="$(mktemp)"
TPL_AFTER="$(mktemp)"
_content_line="$(grep -n '{{CONTENT}}' "$TEMPLATE_FILE" | head -1 | cut -d: -f1)"
head -n $((_content_line - 1)) "$TEMPLATE_FILE" > "$TPL_BEFORE"
tail -n +$((_content_line + 1)) "$TEMPLATE_FILE" > "$TPL_AFTER"

cleanup_templates() { rm -f "$TPL_BEFORE" "$TPL_AFTER"; }
trap cleanup_templates EXIT

# Build HTML by concatenating pre-split template parts around content
build_html() {
  local md_file="$1"
  local output_file="$2"
  local page_title="$3"

  {
    sed \
      -e "s|{{TITLE}}|${TRIP_NAME} — ${page_title}|g" \
      -e "s|{{TRIP_NAME}}|${TRIP_NAME}|g" \
      -e "s|{{PAGE_TITLE}}|${page_title}|g" \
      "$TPL_BEFORE"
    md_to_html "$md_file"
    sed \
      -e "s|{{TITLE}}|${TRIP_NAME} — ${page_title}|g" \
      -e "s|{{TRIP_NAME}}|${TRIP_NAME}|g" \
      -e "s|{{PAGE_TITLE}}|${page_title}|g" \
      "$TPL_AFTER"
  } > "$output_file"
}

# --- Generate HTML for each markdown file ---
echo "Generating HTML files for: $TRIP_NAME"

file_count=0
index_links=""

for mdfile in "$TRIP_DIR"/*.md; do
  [ -f "$mdfile" ] || continue
  filename="$(basename "$mdfile")"

  # Skip index file
  if [ "$filename" = "_index.md" ]; then
    continue
  fi

  display_name="$(get_display_name "$filename")"
  html_name="$(get_html_name "$filename")"

  echo "  Converting: $filename -> html/$html_name"
  build_html "$mdfile" "$TRIP_DIR/html/$html_name" "$display_name"

  # Collect links for index page
  index_links="${index_links}<li><a href=\"${html_name}\">${display_name}</a></li>\n"
  file_count=$((file_count + 1))
done

# --- Generate index.html landing page ---
echo "  Generating: html/index.html"

{
  sed \
    -e "s|{{TITLE}}|${TRIP_NAME} — Trip Hub|g" \
    -e "s|{{TRIP_NAME}}|${TRIP_NAME}|g" \
    -e "s|{{PAGE_TITLE}}|Trip Hub|g" \
    "$TPL_BEFORE"
  echo "<h1>${TRIP_NAME}</h1>"
  echo '<p class="text-muted">Your complete trip documentation — mobile-friendly, offline-ready.</p>'
  echo '<h2>All Guides</h2>'
  echo '<ul>'
  echo -e "$index_links"
  echo '</ul>'
  echo '<hr>'
  echo '<h2>Quick Access</h2>'
  echo '<ul>'
  echo '<li><a href="pocket-guide.html"><strong>Pocket Guide</strong> — Essential daily reference</a></li>'
  echo '<li><a href="itinerary.html"><strong>Itinerary</strong> — Day-by-day plan</a></li>'
  echo '<li><a href="checklists.html"><strong>Checklists</strong> — Interactive to-do lists</a></li>'
  echo '<li><a href="food-guide.html"><strong>Food Guide</strong> — Where to eat</a></li>'
  echo '<li><a href="maps-and-routes.html"><strong>Maps</strong> — Clickable maps & directions</a></li>'
  echo '</ul>'
  echo '<hr>'
  echo '<p class="text-small text-muted">Generated by /travel-agent. All content is inline — no internet required.</p>'
  sed \
    -e "s|{{TITLE}}|${TRIP_NAME} — Trip Hub|g" \
    -e "s|{{TRIP_NAME}}|${TRIP_NAME}|g" \
    -e "s|{{PAGE_TITLE}}|Trip Hub|g" \
    "$TPL_AFTER"
} > "$TRIP_DIR/html/index.html"

echo ""
echo "Done! Generated $file_count HTML files + index.html in $TRIP_DIR/html/"
echo "Open $TRIP_DIR/html/index.html to browse your trip."
