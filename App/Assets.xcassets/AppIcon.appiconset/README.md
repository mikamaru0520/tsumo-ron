# TsumoRon App Icon Design Specification

## Overview
The app icon should feature the TsumoRonMark (tilted point stick character) on a gradient background.

## Design Elements

### Background
- **Type**: Radial or Linear Gradient
- **Colors**:
  - Primary: `#FF6B6B` (AppPrimary - Coral)
  - Secondary: `#4ECDC4` (AppAccent - Mint)
- **Gradient Direction**: Top-left to bottom-right for linear, or center-out for radial

### Logo (TsumoRonMark)
- **Position**: Centered
- **Color**: White (#FFFFFF)
- **Shadow**: Subtle drop shadow for depth
  - Color: Black with 20% opacity
  - Offset: 2-3px down and right
  - Blur: 4-6px

### Icon Sizes Required
- **1024x1024**: App Store icon (required)
- iOS automatically generates all other sizes from this

## Implementation Notes

### Current Status
The `Contents.json` is configured for a single 1024x1024 universal icon (iOS modern format).

### To Create the Icon
1. Create a 1024x1024 canvas
2. Apply the gradient background (AppPrimary to AppAccent)
3. Render the TsumoRonMark at approximately 60-70% of the icon size
4. Center the mark
5. Add the subtle shadow effect
6. Export as PNG and name it as specified in Contents.json

### Design Tips
- Ensure the point stick character is clearly visible at small sizes (60x60, 40x40)
- The 15-degree tilt of the character should be preserved
- The facial features (eyes and smile) should remain visible even at smaller icon sizes
- Consider slightly thicker lines for the face features if they become hard to see at small sizes

## Color Reference
```swift
// From AppColors.swift
AppPrimary: #FF6B6B (rgba(255, 107, 107, 1.0))
AppAccent: #4ECDC4 (rgba(78, 205, 196, 1.0))
```

## TsumoRonMark Proportions
Refer to `/App/Views/Components/TsumoRonMark.swift` for exact proportions:
- Body: 2.5x width, 0.6x height (relative to size parameter)
- Eyes: 0.12x diameter
- Mouth: Arc with 0.25x width, 0.15x height
- Rotation: 15 degrees
- Overall frame: 2.8x width, 1.2x height
