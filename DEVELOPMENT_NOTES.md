# Damascus Pattern Simulator - Development Notes
## Version 1.4 - January 26, 2026

### Critical Understanding: C and W Pattern Damascus

#### Real-World Forging Process

**C Pattern Creation:**
1. Start with simple alternating layers (horizontal white/black)
2. Forge weld layers together under heat and pressure
3. Compress the welded billet on a 45° bias angle
4. The compression causes edges to fold inward, creating C-shaped curves
5. Result: Layers form a C/arc shape

**W Pattern Creation:**
1. Start with C-pattern billet (from above)
2. Draw out (stretch) the C-pattern billet to desired length
3. Clean the surface thoroughly
4. Cut into multiple pieces
5. **Stack pieces VERTICALLY** (on top of each other, like pancakes)
6. Forge weld the stacked pieces together
7. Result: Repeating C curves create the W wave pattern

#### Visual Representation in Simulator

**C Pattern (Single C across full width):**
- One complete C curve spanning the canvas
- Uses sinusoidal wave + parabolic edge curvature
- `wave_amplitude = 40` for the flowing pattern
- Edge curve simulates the inward fold from compression

**W Pattern (Two C's side-by-side):**
- Canvas split vertically in half (`half_width = size / 2`)
- Left half: Full C pattern (0 to 1 normalized)
- Right half: Full C pattern (0 to 1 normalized)
- Each half independently calculates the C curve
- Result: Two interlocking C patterns creating W shape

**Why the visual differs from forging:**
- FORGING: C's stacked vertically (manufacturing process)
- VISUAL: C's shown side-by-side (what you see on blade edge)
- Both are correct representations for their context!

#### Code Implementation Details

```python
# C Pattern (damascus_simulator.py ~line 741)
def create_c_pattern():
    # Full width C pattern
    for y in range(size):
        for x in range(size):
            x_normalized = x / size  # 0 to 1 across full width
            wave_offset = math.cos(x_normalized * math.pi * 2) * wave_amplitude * 1.2
            distance_from_center = abs(x_normalized - 0.5) * 2
            edge_curve = (distance_from_center ** 2) * wave_amplitude * 1.0
            total_offset = int(wave_offset + edge_curve)
            distorted_y = y + total_offset
            color = get_layer_color_at_position(distorted_y)

# W Pattern (damascus_simulator.py ~line 677)
def create_w_pattern():
    # Split canvas for two C patterns
    half_width = size / 2
    for y in range(size):
        for x in range(size):
            if x < half_width:
                x_normalized = x / half_width  # 0 to 1 in left half
            else:
                x_normalized = (x - half_width) / half_width  # 0 to 1 in right half
            # Same C pattern calculation for each half
            wave_offset = math.cos(x_normalized * math.pi * 2) * wave_amplitude * 1.2
            distance_from_center = abs(x_normalized - 0.5) * 2
            edge_curve = (distance_from_center ** 2) * wave_amplitude * 1.0
            # Result: Two complete C patterns side-by-side
```

### Export Steps Feature

#### Purpose
Generate multi-page PDF guides showing the complete forging progression for any pattern combination.

#### Structure

**Page 1: Introductory Instructions**
- Title: "Damascus Pattern Forging Process"
- All steps numbered continuously (Step 1, 2, 3, 4, 5...)
- Organized by transformation sections:
  - "Creating C Pattern from Simple Layers:"
  - "Creating W Pattern from C Pattern:"
  - "Rotation:", "Mosaic:", "Twist:", "Grinding:"

**Subsequent Pages: Visual Progression**
- Each transformation step shown as a separate page
- Title only (e.g., "1. Simple Alternating Layers (Base)")
- Large pattern image centered on canvas
- No duplicate instructions (all on page 1)

#### Step Descriptions (damascus_simulator.py ~line 1488)

```python
step_descriptions = {
    "base_to_C": [
        "Forge weld the alternating layers together under heat and pressure to create a solid billet.",
        "Compress the welded billet on a 45° bias. The compression causes edges to fold inward, creating C-shaped curves."
    ],
    "C_to_W": [
        "Draw out (stretch) the C-pattern billet to desired length.",
        "Clean the surface, cut into pieces, and restack them vertically (on top of each other).",
        "Forge weld the restacked C-pattern pieces together. The repeating stacked C curves create the W wave pattern."
    ],
    "to_Rotation": [...],
    "to_Mosaic": [...],
    "to_Twist": [...],
    "to_Grind": [...]
}
```

#### Implementation Notes

1. **Intro Page Generation** (~line 1501):
   - Creates 1600×2000 white canvas
   - Title at top in 40pt bold font
   - Iterates through transformation_steps to build instruction list
   - Groups related steps under section headings
   - Numbers steps continuously across all sections

2. **Pattern Page Generation** (~line 1562):
   - Scales pattern images to max 1400px wide
   - Canvas width set to 1600px minimum (room for long titles)
   - Pattern images centered horizontally
   - Title at y=60 position
   - No descriptions (all on intro page)

3. **Transformation Detection** (~line 1521):
   - Checks current_step → next_step transitions
   - Matches against known pattern types
   - Only shows instructions once per transition
   - Handles C, W, Rotation, Mosaic, Twist, Grind

### UI Layout Changes (Version 1.4)

**Horizontal Layout:**
- Canvas width: 1350px (was 900px)
- Canvas height: 500px (was 700px)
- Menu controls: Top of window
- Transformation controls: Bottom of window (horizontal scroll)
- Canvas: Center, full width, with dynamic resize

**Dynamic Resizing:**
- Canvas binds to `<Configure>` event
- Updates `self.canvas_width` and `self.canvas_height` on resize
- Calls `update_canvas_background()` to redraw green background + logo
- Calls `update_pattern()` to recenter pattern on new canvas size

**Pattern Centering:**
- Calculate position: `x = (canvas_width - img.width) // 2`
- Pattern stays centered regardless of window size
- Background scales with canvas

### Key Files Modified

1. **damascus_simulator.py**
   - Lines 677-740: W pattern with detailed comments
   - Lines 741-788: C pattern with detailed comments
   - Lines 1184-1208: Helper to generate simple layers for export
   - Lines 1219-1248: Helper to generate C pattern for export
   - Lines 1258-1287: Update pattern with C/W progression tracking
   - Lines 1485-1610: Complete export_steps function

2. **README.md**
   - Lines 15-21: Updated pattern descriptions
   - Lines 65-72: Export Steps feature documentation
   - Lines 290-303: Version 1.4 history

### Testing Notes

- W pattern correctly shows two C's side-by-side
- C pattern shows single C curve with proper edge fold
- Export Steps PDF includes all 5 forging steps for W pattern
- Export Steps works for any pattern combination
- Instructions match real-world damascus forging process

### Future Considerations

- Pattern library system (save/load favorite patterns)
- 3D visualization of billet cross-sections
- Animation of forging process
- More pattern types (feather, ladder, raindrop)
- Custom color schemes beyond white/black

### Developer Reminders

**When working on patterns:**
- Simple layers are ALWAYS the base
- C and W are transformations, not base patterns
- W pattern is built from C patterns
- Visual representation ≠ forging process (but both are valid!)

**When working on Export Steps:**
- Step descriptions in `step_descriptions` dict
- Transitions detected by checking current → next step names
- Steps numbered continuously across all sections
- Keep visual pages clean (title + image only)

---
*Last Updated: January 26, 2026*
*Version: 1.4*
