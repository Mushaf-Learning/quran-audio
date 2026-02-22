#!/usr/bin/env bash
#
# download_reciter.sh
#
# Downloads all ayah audio files for a given reciter from EveryAyah.com.
#
# Usage:
#   ./download_reciter.sh <reciter_subfolder> [output_directory]
#
# Examples:
#   ./download_reciter.sh Alafasy_128kbps
#   ./download_reciter.sh Alafasy_128kbps ./audio/alafasy
#   ./download_reciter.sh Husary_Muallim_128kbps /data/audio/husary-muallim
#
# The script downloads files in the format SSS_AAA.mp3 where:
#   SSS = 3-digit surah number (001-114)
#   AAA = 3-digit ayah number (001-286, varies by surah)
#
# It also downloads the Bismillah file (001_001.mp3) which serves as
# the Bismillah audio for surahs that begin with it.

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
BASE_URL="https://everyayah.com/data"

# Ayah counts for all 114 surahs (index 0 = Al-Fatiha, index 113 = An-Nas)
AYAH_COUNTS=(
  7 286 200 176 120 165 206 75 129 109
  123 111 43 52 99 128 111 110 98 135
  112 78 118 64 77 227 93 88 69 60
  34 30 73 54 45 83 182 88 75 85
  54 53 89 59 37 35 38 29 18 45
  60 49 62 55 78 96 29 22 24 13
  14 11 11 18 12 12 30 52 52 44
  28 28 20 56 40 31 50 40 46 42
  29 19 36 25 22 17 19 26 30 20
  15 21 11 8 8 19 5 8 8 11
  11 8 3 9 5 4 7 3 6 3
  5 4 5 6
)

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <reciter_subfolder> [output_directory]"
  echo ""
  echo "  reciter_subfolder  The folder name used in EveryAyah URLs (e.g. Alafasy_128kbps)"
  echo "  output_directory   Where to save files (default: ./audio/<reciter_subfolder>)"
  echo ""
  echo "Examples:"
  echo "  $0 Alafasy_128kbps"
  echo "  $0 Husary_Muallim_128kbps ./my-audio-dir"
  exit 1
fi

RECITER_SUBFOLDER="$1"
OUTPUT_DIR="${2:-./audio/${RECITER_SUBFOLDER}}"

# ---------------------------------------------------------------------------
# Preparation
# ---------------------------------------------------------------------------
mkdir -p "$OUTPUT_DIR"

# Calculate total ayahs for progress reporting
TOTAL_AYAHS=0
for count in "${AYAH_COUNTS[@]}"; do
  TOTAL_AYAHS=$((TOTAL_AYAHS + count))
done

echo "=============================================="
echo "  EveryAyah Audio Downloader"
echo "=============================================="
echo "  Reciter:    ${RECITER_SUBFOLDER}"
echo "  Output:     ${OUTPUT_DIR}"
echo "  Total:      ${TOTAL_AYAHS} ayahs across 114 surahs"
echo "  Source:     ${BASE_URL}/${RECITER_SUBFOLDER}/"
echo "=============================================="
echo ""

# ---------------------------------------------------------------------------
# Download
# ---------------------------------------------------------------------------
DOWNLOADED=0
SKIPPED=0
FAILED=0
CURRENT=0

for surah_index in "${!AYAH_COUNTS[@]}"; do
  surah_num=$((surah_index + 1))
  ayah_count="${AYAH_COUNTS[$surah_index]}"
  surah_padded=$(printf "%03d" "$surah_num")

  for ayah_num in $(seq 1 "$ayah_count"); do
    ayah_padded=$(printf "%03d" "$ayah_num")
    filename="${surah_padded}${ayah_padded}.mp3"
    url="${BASE_URL}/${RECITER_SUBFOLDER}/${filename}"
    output_path="${OUTPUT_DIR}/${filename}"
    CURRENT=$((CURRENT + 1))

    # Skip if already downloaded
    if [[ -f "$output_path" ]]; then
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    # Progress display
    percent=$((CURRENT * 100 / TOTAL_AYAHS))
    printf "\r[%3d%%] Surah %3d/%d  Ayah %3d/%3d  |  Downloaded: %d  Skipped: %d  Failed: %d" \
      "$percent" "$surah_num" 114 "$ayah_num" "$ayah_count" \
      "$DOWNLOADED" "$SKIPPED" "$FAILED"

    # Download with retry
    if curl -sS -f --connect-timeout 10 --max-time 60 -o "$output_path" "$url" 2>/dev/null; then
      DOWNLOADED=$((DOWNLOADED + 1))
    else
      FAILED=$((FAILED + 1))
      # Remove partial download if any
      rm -f "$output_path"
      echo ""
      echo "  WARNING: Failed to download ${filename} from ${url}"
    fi

    # Small delay to be respectful to the server
    sleep 0.1
  done
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo ""
echo "=============================================="
echo "  Download Complete"
echo "=============================================="
echo "  Downloaded:  ${DOWNLOADED} files"
echo "  Skipped:     ${SKIPPED} files (already existed)"
echo "  Failed:      ${FAILED} files"
echo "  Total:       ${CURRENT} ayahs"
echo "  Output:      ${OUTPUT_DIR}"
echo "=============================================="

if [[ $FAILED -gt 0 ]]; then
  echo ""
  echo "  Some downloads failed. Re-run the script to retry."
  echo "  Already-downloaded files will be skipped."
  exit 1
fi
