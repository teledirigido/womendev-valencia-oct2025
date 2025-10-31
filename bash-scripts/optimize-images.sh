#!/bin/bash

# Image optimization script
# Converts PNG images to WebP format for better compression
# Preserves original files in case you need them

set -e

IMAGE_DIR="public/images"
QUALITY=85  # WebP quality (0-100, 85 is high quality with good compression)

echo "🖼️  Image Optimization Script"
echo "=============================="
echo ""

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "❌ Error: cwebp is not installed"
    echo "Install with: brew install webp"
    exit 1
fi

# Check if image directory exists
if [ ! -d "$IMAGE_DIR" ]; then
    echo "❌ Error: Directory $IMAGE_DIR not found"
    exit 1
fi

echo "📁 Searching for PNG images in $IMAGE_DIR..."
echo ""

# Find all PNG files
PNG_FILES=$(find "$IMAGE_DIR" -type f -name "*.png")

if [ -z "$PNG_FILES" ]; then
    echo "ℹ️  No PNG files found"
    exit 0
fi

# Count files
TOTAL=$(echo "$PNG_FILES" | wc -l | tr -d ' ')
echo "Found $TOTAL PNG file(s) to optimize"
echo ""

CONVERTED=0
TOTAL_SAVED=0

# Process each PNG file
while IFS= read -r png_file; do
    # Skip if file doesn't exist
    [ ! -f "$png_file" ] && continue

    # Get file size before
    SIZE_BEFORE=$(stat -f%z "$png_file" 2>/dev/null || stat -c%s "$png_file" 2>/dev/null)
    SIZE_BEFORE_KB=$((SIZE_BEFORE / 1024))

    # Generate WebP filename
    webp_file="${png_file%.png}.webp"

    # Convert to WebP
    echo "🔄 Converting: $(basename "$png_file")"
    echo "   Before: ${SIZE_BEFORE_KB}KB"

    if cwebp -q $QUALITY "$png_file" -o "$webp_file" 2>/dev/null; then
        # Get file size after
        SIZE_AFTER=$(stat -f%z "$webp_file" 2>/dev/null || stat -c%s "$webp_file" 2>/dev/null)
        SIZE_AFTER_KB=$((SIZE_AFTER / 1024))

        # Calculate savings
        SAVED=$((SIZE_BEFORE - SIZE_AFTER))
        SAVED_KB=$((SAVED / 1024))
        PERCENT=$((100 - (SIZE_AFTER * 100 / SIZE_BEFORE)))

        echo "   After:  ${SIZE_AFTER_KB}KB (saved ${SAVED_KB}KB, -${PERCENT}%)"
        echo "   ✅ Created: $(basename "$webp_file")"
        echo ""

        CONVERTED=$((CONVERTED + 1))
        TOTAL_SAVED=$((TOTAL_SAVED + SAVED))
    else
        echo "   ❌ Failed to convert"
        echo ""
    fi
done <<< "$PNG_FILES"

# Summary
echo "=============================="
echo "📊 Summary"
echo "=============================="
echo "Converted: $CONVERTED/$TOTAL files"

if [ $TOTAL_SAVED -gt 0 ]; then
    TOTAL_SAVED_KB=$((TOTAL_SAVED / 1024))
    TOTAL_SAVED_MB=$((TOTAL_SAVED_KB / 1024))

    if [ $TOTAL_SAVED_MB -gt 0 ]; then
        echo "Total saved: ${TOTAL_SAVED_MB}MB"
    else
        echo "Total saved: ${TOTAL_SAVED_KB}KB"
    fi
fi

echo ""
echo "✨ Done! Now update your markdown files to use .webp instead of .png"
echo ""
echo "Next steps:"
echo "1. Test the WebP images in your browser"
echo "2. Update image references in markdown files (png → webp)"
echo "3. Optionally delete original PNG files to save space"
