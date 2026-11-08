---
name: Lumina Recovery
colors:
  surface: '#10131c'
  surface-dim: '#10131c'
  surface-bright: '#363943'
  surface-container-lowest: '#0b0e17'
  surface-container-low: '#181b25'
  surface-container: '#1c1f29'
  surface-container-high: '#272a33'
  surface-container-highest: '#32343e'
  on-surface: '#e0e2ef'
  on-surface-variant: '#bbcabf'
  inverse-surface: '#e0e2ef'
  inverse-on-surface: '#2d303a'
  outline: '#86948a'
  outline-variant: '#3c4a42'
  surface-tint: '#4edea3'
  primary: '#4edea3'
  on-primary: '#003824'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#006c49'
  secondary: '#4cd7f6'
  on-secondary: '#003640'
  secondary-container: '#03b5d3'
  on-secondary-container: '#00424e'
  tertiary: '#ffb95f'
  on-tertiary: '#472a00'
  tertiary-container: '#e29100'
  on-tertiary-container: '#523200'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#acedff'
  secondary-fixed-dim: '#4cd7f6'
  on-secondary-fixed: '#001f26'
  on-secondary-fixed-variant: '#004e5c'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#10131c'
  on-background: '#e0e2ef'
  surface-variant: '#32343e'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 38px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.03em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-metric:
    fontFamily: JetBrains Mono
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.04em
  label-mono-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-caps:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.08em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style

This design system is tailored for an empowering, habit-breaking companion focused on smoking cessation and pulmonary rejuvenation. It addresses users navigating dopamine withdrawal, stress triggers, and habit rewiring. 

### Atmosphere & Aesthetic
- **Visual Style:** Minimalist Dark Precision meets Ambient Luminescence. Deep, near-absolute dark tones reduce visual fatigue and nighttime anxiety, while precision glowing accents celebrate physical milestones, health recovery, and saved wealth.
- **Personality:** Stoic, clinical yet intensely encouraging, restorative, and sophisticated. It replaces guilt-inducing warnings with biological progress markers, monetary wins, and tranquil breathing cues.
- **Tone:** Direct, affirmative, serene. Interfaces prioritize low-friction check-ins, instantaneous craving-intervention tools, and high-legibility biological telemetry.

## Colors

The palette leverages high-contrast luminescence over atmospheric, layered darks. Accents are assigned strict functional responsibilities:

- **Recovery Emerald (`#10B981`):** Primary action and vital biological regeneration indicator (oxygen levels, lung cilia recovery, smoke-free streaks).
- **Vapor Cyan (`#06B6D4`):** Secondary accent reserved for cognitive mastery, guided breathwork pacing, blood pressure normalization, and nervous system stability.
- **Prosperity Amber (`#F59E0B`):** Tertiary focal point used exclusively for monetary metrics, financial milestones, and reward unlocks.
- **Void Charcoal (`#12151E`):** Base neutral surface, paired with an abyssal canvas foundation (`#090A0F`).

### Functional Palette Matrix
- **Canvas Base:** `#090A0F` (OLED zero-burn background).
- **Surface Elevation 1 (Card/Container):** `#12151E`.
- **Surface Elevation 2 (Elevated Sheet/Modal):** `#1A1E2B`.
- **Surface Elevation 3 (Interactive Controls):** `#222838`.
- **Border Ghost Subdued:** `rgba(255, 255, 255, 0.08)`.
- **Text Primary:** `#F8FAFC`.
- **Text Muted/Secondary:** `#94A3B8`.
- **Alert / Craving Hazard:** `#EF4444`.

## Typography

The type system balances organic comfort with clinical precision. 

- **Primary & Headline (`Plus Jakarta Sans`):** Features rounded grotesque terminals that feel humane and encouraging without appearing juvenile. It keeps micro-copy legible in low-light environments.
- **Metrics & Telemetry (`JetBrains Mono`):** Applied to counters, elapsed recovery timers, currency savings tickers, and biological percentage scores. It reinforces tangible, progressive milestones and measurable health reconstruction.
- **Hierarchy Rules:** Large numbers (`label-metric`) should be paired directly with compact uppercase tags (`label-caps`) to maintain a clean dashboard dashboard look.

## Layout & Spacing

Mobile-first single-column structural grid system built strictly on an 8-point base rhythm (with 4-point micro-adjustments).

### Layout Geometry
- **Screen Margins:** Fixed `1.25rem` (20px) horizontal inset ensures thumb reachability while preventing edge-clipping on curved modern glass displays.
- **Gutters & Nested Cards:** Internal card gaps strictly adhere to `0.75rem` or `1rem` to maintain scannability across dense data tiles (e.g., Blood Circulation, Carbon Monoxide drop, Financial Savings).
- **Safe Area Insets:** Fixed vertical clearance of `3rem` to accommodate dynamic notches, pill cameras, and gesture navigation bars.

## Elevation & Depth

This system avoids heavy drop shadows, relying on tonal layering, tinted edge highlights, and subtle atmospheric glows to establish depth.

- **Base Layer (0dp):** Pitch Black `#090A0F`.
- **Card Tier 1 (1dp):** Charcoal Slate `#12151E` surfaced with a crisp 1px perimeter stroke of `rgba(255, 255, 255, 0.06)`.
- **Floating Modals & Urgent Drawers (2dp):** Surface `#1A1E2B` accompanied by a localized ambient shadow: `0px 16px 32px -8px rgba(0, 0, 0, 0.6)`.
- **Luminescent Accent Nodes:** Key milestones and interactive progress rings project an ambient colored glow:
  - Recovery Indicators: `box-shadow: 0px 0px 24px -4px rgba(16, 185, 129, 0.25)`
  - Emergency Panic Craving Buttons: `box-shadow: 0px 0px 32px 0px rgba(6, 182, 212, 0.35)`
- **Glass Shards:** Translucent sticky headers and navigation bars utilize `rgba(9, 10, 15, 0.82)` with `backdrop-filter: blur(16px)` and a bottom border `rgba(255, 255, 255, 0.05)`.

## Shapes

The interface embraces a unified curvature hierarchy (`roundedness: 2` = 0.5rem base) to maintain an ergonomic, tactile feel.

- **Micro Controls (Badges, Tooltips):** 0.375rem (6px) to 0.5rem (8px).
- **Cards, Metrics Tiles & Input Modules:** 1rem (16px) border-radius (`rounded-lg`).
- **Sheets, Modal Dialogs & Craving Overlays:** 1.5rem (24px) border-radius (`rounded-xl`).
- **Buttons, Steppers, Quick Log Chips:** Fully pill-shaped (`9999px`) to emphasize touch affordances and contrast against structured square metrics cards.

## Components

### Buttons
- **Primary Recovery CTA:** Pill-shaped, gradient-infused background from `#10B981` to `#059669`, label in `#090A0F` (bold, maximum contrast), elevated with a soft emerald ambient glow.
- **Craving SOS Button:** High-priority round floating button; deep slate `#1A1E2B` housing a pulsing `#06B6D4` breathing ring to quickly redirect users into grounding exercises.
- **Secondary Ghost:** 1px stroke `rgba(255, 255, 255, 0.12)`, transparent fill, text `#F8FAFC`, active state filling with `rgba(255, 255, 255, 0.05)`.

### Cards & Telemetry Tiles
- **Structure:** `#12151E` background, 16px corner radius, internal padding of `1rem`.
- **Metric Tiles (Savings & Biological Timers):** Display `label-caps` in `#94A3B8`, primary counter in `label-metric`, and progress indicators directly integrated into card borders or segmented circular rings.

### Progress & Health Rings
- Multi-tier nested radial rings on `#090A0F`. Background track uses `rgba(255, 255, 255, 0.05)`.
- Active paths feature high-saturation rounded linecaps in `#10B981` (Cilia), `#06B6D4` (Oxygenation), and `#F59E0B` (Money Saved).

### Chips & Badges
- Compact pill geometries. 
- Inactive state: `#1A1E2B` surface with muted text.
- Active milestone badge: `rgba(16, 185, 129, 0.12)` background with `#10B981` text and an inline glow indicator dot.

### Inputs & Sliders
- **Craving Intensity Slider:** Track spans from `#10B981` (Low) transitioning through `#F59E0B` to `#EF4444` (Severe). Custom thumb knob with dual-tone ring for precise touch feedback.
- **Journal/Log Field:** Surface `#12151E`, border `rgba(255, 255, 255, 0.08)`, transitioning to `#10B981` on focus with zero layout shift.

### Breathing / Pacer Component
- Centered concentric ripples with `rgba(6, 182, 212, 0.15)` expansion states, directing inhalation, retention, and exhalation rhythms during craving episodes.