---
name: Pastel Arctic Warmth
colors:
  surface: '#f6faff'
  surface-dim: '#d4dbe3'
  surface-bright: '#f6faff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#edf4fc'
  surface-container: '#e8eff7'
  surface-container-high: '#e2e9f1'
  surface-container-highest: '#dce3eb'
  on-surface: '#151c22'
  on-surface-variant: '#424754'
  inverse-surface: '#2a3137'
  inverse-on-surface: '#eaf1f9'
  outline: '#727785'
  outline-variant: '#c2c6d6'
  surface-tint: '#005ac2'
  primary: '#0058be'
  on-primary: '#ffffff'
  primary-container: '#2170e4'
  on-primary-container: '#fefcff'
  inverse-primary: '#adc6ff'
  secondary: '#4059aa'
  on-secondary: '#ffffff'
  secondary-container: '#8fa7fe'
  on-secondary-container: '#1d3989'
  tertiary: '#006947'
  on-tertiary: '#ffffff'
  tertiary-container: '#00855b'
  on-tertiary-container: '#f5fff6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004395'
  secondary-fixed: '#dce1ff'
  secondary-fixed-dim: '#b6c4ff'
  on-secondary-fixed: '#00164e'
  on-secondary-fixed-variant: '#264191'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#f6faff'
  on-background: '#151c22'
  surface-variant: '#dce3eb'
  accent-sun: '#FDE047'
  accent-orange: '#FB923C'
  accent-blush: '#FDA4AF'
  accent-sprout: '#34D399'
  cloud-blue: '#93C5FD'
  success-light: '#D1FAE5'
  streak-amber: '#F59E0B'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.03em
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '800'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '800'
    lineHeight: 32px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-brand-sub:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.1em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  margin: 1.25rem
  margin-sm: 1rem
  margin-lg: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.75rem
  space-2xl: 2.5rem
---

## Brand & Style

The design system establishes a warm, emotionally supportive habit-tracking experience designed to lower cognitive resistance and celebrate micro-achievements ("Small Tick") as catalysts for compounding personal evolution ("Big Grow"). 

Its personality blends gentle arctic calm with uplifting optimism—embodying an encouraging companion rather than a rigid disciplinarian. The primary emotional tone is safe, joyful, and tactile, anchored by a round-cheeked penguin mascot who acknowledges effort through subtle celebrations, cozy feedback loops, and empathetic emotional check-ins.

The visual style couples **Modern Soft Minimalism** with **Tactile / Pastel Delight**:
- Airy, soft sky-tinted canvases eliminate the clinical feel of traditional productivity dashboards.
- Generous, organic corner curves (`rounded-2xl` and `rounded-3xl`) ensure that every interactive touchpoint feels friendly, safe, and squishable.
- Physical micro-interactions—delicate scale depressions on tap (`scale: 0.98`), springy confetti explosions on check-off, and glowing pastel states—turn repetitive routines into rewarding rituals.

## Colors

The palette derives inspiration from an arctic dawn: icy ambient blues warmed by sunrise yellows, lively garden sprouts, and rosy penguin cheeks.

- **Primary Sky Blue (`#3B82F6`)**: The operational core of the application. Used for primary calls-to-action, active bottom tab icons, interactive outlines, and core brand elements.
- **Deep Navy (`#1E3A8A`)**: Provides visual gravity, deep legibility for headline typography, and contrast against soft tinted backdrops.
- **Tertiary Mint Green (`#10B981` / `#34D399`)**: Dedicated to completed micro-victories, the confirmation tick, progress rings, and streaks. It symbolizes fresh shoots breaking through ice.
- **Neutral Ice Tint (`#F0F7FF`)**: The default canvas backdrop, preventing harsh clinical glare while retaining a crisp, serene ambience.
- **Accents**: 
  - `accent-blush` (`#FDA4AF`): Expresses character warmth, mood logs, and penguin cheek details.
  - `accent-sun` (`#FDE047`): Surfaces gold milestone badges and cheerful dawn highlights.
  - `accent-orange` (`#FB923C`): Mascot beak accents and burning habit streaks.

### Color Hierarchy & Roles
1. Never use pure black (`#000000`) for text. Use `#0F172A` for high-emphasis primary text and `#64748B` for secondary text to preserve soft contrast.
2. Surfaces must prioritize clean card white (`#FFFFFF`) against the tinted `#F0F7FF` canvas to create crisp physical layers without stark outlines.
3. Completed habit items transition text to `#94A3B8` with a line-through, while the container subtly washes with `#D1FAE5` at low opacity.

## Typography

The typography relies completely on **Plus Jakarta Sans**, chosen for its friendly geometric curves, broad apertures, and clean legibility at compact mobile scale.

- **Brand Dual Lockup**: The logotype pairs two deliberate weights. `label-brand-sub` ("Small Tick") uses light-to-regular weight, airy uppercase tracking (`letter-spacing: 0.1em`), and soft sky blue. Beneath it, "Big Grow" leverages `headline-lg` (`font-weight: 800`) with tighter tracking (`-0.02em`) in `Deep Navy` to symbolize cumulative strength.
- **Content Hierarchy**: Habit item labels use `body-lg` at semibold weight (`600`) to guarantee rapid reading while walking or commuting. Sub-meta (streaks, frequency, completion percentage) uses `body-sm` at regular weight in muted slate.
- **Interactive Links**: Text actions ("Sign In", "Forgot Password", "Skip") use `label-md` with 4px underline offsets (`text-underline-offset: 4px`) tinted with `#2563EB`.

## Layout & Spacing

The layout philosophy follows a mobile-first, thumb-accessible fluid approach built on an 8-point rhythmic grid with a 4-point micro step.

- **Canvas & Gutters**: Outer margins anchor at `1.25rem` (20px) on standard smartphones, collapsing gracefully to `1rem` (16px) on compact screens (<375px) and expanding to `1.5rem` (24px) on tablet viewports. Column gutters inside cards and lists hold at `1rem`.
- **Vertical Ergonomics**: Primary action triggers (the floating "+" button, habit check taps, and bottom sheets) reside within the natural bottom thumb zone (lower 40% of the display). 
- **Component Padding Scale**:
  - `space-xs` (4px): Inner badge padding, icon-to-badge gaps.
  - `space-sm` (8px): Habit metadata spacing, pill button horizontal inner paddings.
  - `space-md` (16px): Standard habit card padding, input field padding.
  - `space-lg` (20px): Bottom modal interior padding, section separation.
  - `space-xl` (28px): Spacer between header hero stats and habit queues.
  - `space-2xl` (40px): Empty-state illustration vertical margins.

## Elevation & Depth

Visual depth is achieved through **Soft Tonal Layering and Tinted Ambient Shadows**, avoiding harsh drop shadows or flat corporate borders.

- **Ambient Tinting**: Shadows are never pure gray. They absorb 4% to 8% of the brand's deep navy (`rgba(30, 58, 138, ...)`), giving elevation a natural sky-cast glow.
- **Surface Elevation Levels**:
  - **Level 0 (Canvas Base)**: `#F0F7FF` flat background.
  - **Level 1 (Habit Cards & Inputs)**: `#FFFFFF` resting on `box-shadow: 0 10px 25px -5px rgba(30, 58, 138, 0.06), 0 4px 6px -2px rgba(30, 58, 138, 0.03)`. A crisp hairline outline (`1px solid #E2E8F0` at 60% opacity) defines edges against light backgrounds.
  - **Level 2 (Floating Action Buttons & Bottom Navigation Bar)**: Floating items feature active ambient glow: `box-shadow: 0 12px 28px -4px rgba(59, 130, 246, 0.28)`.
  - **Level 3 (Modals & Bottom Sheets)**: `box-shadow: 0 20px 40px -12px rgba(15, 23, 42, 0.22)`. The underlying viewport is overlaid with a soft frosted veil (`backdrop-filter: blur(8px); background: rgba(15, 23, 42, 0.35)`).
- **Pressed & Active Feedback**: When pressed, cards drop to `box-shadow: 0 2px 4px rgba(30, 58, 138, 0.04)` accompanied by a mechanical scale down (`scale: 0.98`), providing immediate physical reassurance.

## Shapes

The design system enforces a pillowy, organic geometry. Sharp edges (`0px`) are forbidden. 

- **Level 2 Foundation**: Default interactive elements (cards, text fields, notification banners) use `rounded-2xl` (16px / 1rem). 
- **Hero & Modal Curvature**: High-containment surfaces (bottom sheets, hero highlight boxes, floating bottom navigation capsules) deploy `rounded-3xl` (24px to 32px / 1.5rem to 2rem).
- **Checkpoints & Avatars**: Mascot avatars, checkmark triggers, and status pills adopt full pill shapes (`rounded-full` / 9999px) to maintain a playful, squircle aesthetic across touch targets.

## Components

### 1. Buttons
- **Primary Action**: Gradient fill (`linear-gradient(135deg, #1E40AF 0%, #3B82F6 50%, #60A5FA 100%)`), white bold text, `rounded-2xl`, height: 52px. Accompanied by a colored sky glow (`box-shadow: 0 8px 20px rgba(59, 130, 246, 0.35)`).
- **Secondary / Soft Button**: Pale pastel blue background (`#E0F2FE`), primary blue text (`#1E40AF`), `rounded-2xl`.
- **Micro-Action / Tick Target**: 44x44px rounded circular trigger on the right side of habit rows. Inactive state: 2px dashed/solid border in `#93C5FD`. Active state: morphs with a bouncy spring into a vibrant mint gradient (`#10B981` to `#34D399`) bearing a crisp white checkmark (`✓`).

### 2. Habit Card ("Small Tick" Row)
- Layout: 3-column horizontal flexbox inside a pure white `rounded-2xl` container.
- Left: 44px circular pastel category badge (`💧` hydrated blue, `📖` study yellow, `🏃` active mint).
- Middle: Habit label (`body-lg`), followed by a metadata row showing current streak (`🔥 7 Günlük Seri / 7-Day Streak`) and frequency tags.
- Right: Checkbox trigger button.
- Completed Behavior: Smooth opacity reduction of the title to 50%, strike-through animation, and a delicate mint rim border.

### 3. Checkboxes & Radio Controls
- Custom circular radios and check squares with 12px rounded corners.
- Selected state fills with mint green (`#10B981`) or sky blue (`#3B82F6`) with animated SVG tick draw-in.

### 4. Input Fields
- Background: Soft tinted slate (`#F8FAFC`).
- Height: 50px, border: `1.5px solid #E2E8F0`, corner radius: `rounded-xl`.
- Focus State: Smooth glow outline in `#3B82F6` with `0 0 0 3px rgba(59, 130, 246, 0.15)`.

### 5. Chips & Filter Pills
- Used in the calendar view for date ranges (1W, 2W, 1M, 3M).
- Unselected: White surface with muted gray text and 1px border.
- Selected: Primary sky blue background with pure white typography and gentle ambient shadow.

### 6. Reflection Bottom Sheet (Mindfulness Check-in)
- Slides from bottom with `rounded-t-3xl` corners and a 40x4px gray grabber pill.
- Title: *"Bu adımı tamamlamak sana nasıl hissettirdi?"* ("How did completing this step feel?")
- Emoji Selector: 5 circular mood pills (🤩, 😊, 😌, 🥱, 🤯) sized at 54px with bounce hover states.
- Reflection Input: Subtle rounded textarea for journaling reflections before continuing.

### 7. Empty State Illustration Card
- Centered cheerful penguin illustration with pink blush cheeks (`#FDA4AF`), holding a tiny task notebook.
- Reassuring copy: *"Büyük hedefler, küçük bir tik ile başlar"* ("Big goals start with a small tick").
- Direct CTA: `+ İlk Alışkanlığını Ekle` ("+ Add Your First Habit").