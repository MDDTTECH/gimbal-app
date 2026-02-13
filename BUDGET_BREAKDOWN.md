# GIMBAL CONTROL APP — Budget Breakdown

**Prepared for:** Henry  
**Date:** February 14, 2026  
**Model:** Time & Materials (T&M) — you pay for actual hours worked  

---

## How It Works

- **Hourly rate:** $34/hour (blended average)
- **Invoicing:** End of each sprint — timesheet + demo + invoice
- **Payment:** Within 3 business days of invoice
- **Commitment:** Per-sprint only — you decide after each one

No upfront payments. No lock-in. You see the work before you pay.

---

## MVP Budget — Sprint by Sprint

| Sprint | Duration | Hours | Cost | Deliverable |
|--------|----------|-------|------|-------------|
| **0 — PoC** | 1 week | ~25h | **~$850** | App controls gimbal via WiFi (demo video) |
| **1–2 — Foundation** | 2 weeks | ~70h | **~$2,380** | Full manual control app (joystick, sliders, status) |
| **3–4 — Recording** | 2 weeks | ~60h | **~$2,040** | Record & replay motion sequences |
| **5–6 — Precision** | 2 weeks | ~60h | **~$2,040** | ±0.5° accuracy, drift correction |
| **7 — Detection** | 1 week | ~25h | **~$850** | Motion detection + camera trigger |
| | | | | |
| **MVP TOTAL** | **7–8 weeks** | **~240h** | **~$8,160** | **Complete automated gimbal system** |

---

## What's Included in Each Sprint

### Sprint 0 — $850
```
✓ SDK integration & MAVLink protocol setup
✓ WiFi connection to Gremsy T7
✓ Basic pan/tilt commands from Flutter app
✓ Demo video proving the concept works
```

### Sprint 1–2 — $2,380
```
✓ C++ core engine (MAVLink, connection management)
✓ Flutter ↔ C++ FFI bridge
✓ Joystick control with spring-back
✓ Real-time angle display (pan/tilt/roll gauges)
✓ Mode switching (Follow/Lock/FPV)
✓ Battery & signal monitoring
✓ Auto-reconnect on connection loss
```

### Sprint 3–4 — $2,040
```
✓ Motion recording at 10 Hz
✓ SQLite storage (persistent across restarts)
✓ Basic playback engine
✓ Sequence management (list, rename, delete, favorite)
✓ Recording UI with waveform visualization
```

### Sprint 5–6 — $2,040
```
✓ Cubic spline interpolation (smooth playback)
✓ Firmware clock synchronization
✓ Command buffering (5-10 points ahead)
✓ Drift detection & correction algorithm
✓ 50× repeatability validation
```

### Sprint 7 — $850
```
✓ Frame differencing motion detection
✓ Region of Interest (ROI) selection UI
✓ Auto-trigger: motion → playback → camera
✓ Camera AUX port trigger integration
```

---

## Optional: MVP+ Cloud Features

| Sprint | Duration | Hours | Cost | Deliverable |
|--------|----------|-------|------|-------------|
| **8–9 — Cloud** | 2 weeks | ~60h | **~$2,040** | User accounts, video upload (S3), cross-device sync |

**Total with MVP+:** ~300h | **~$10,200**

---

## Rate Structure

| Work Type | Rate | When |
|-----------|------|------|
| Development (new features) | $30/h | Building new functionality |
| Refinement (debugging, optimization) | $40/h | Fixing, testing, polishing |
| **Blended average** | **~$34/h** | **Typical sprint mix** |

Typical sprint breakdown: ~60% development + ~40% refinement = $34/h average.

---

## Cost Comparison

| Approach | MVP Cost | Risk | Flexibility |
|----------|----------|------|-------------|
| **Fixed price (typical agency)** | $20,000–30,000 | Risk padded into price | Change orders = extra cost |
| **Our T&M approach** | **~$8,160** | You pay for actual work | Change direction any sprint |
| **Difference** | **~$12,000–22,000 saved** | Risk on us, not you | Full control |

Why the difference?
- No risk padding — you don't pay for "what ifs"
- AI-assisted development — 30-40% efficiency on boilerplate
- Focused expertise — C++ + Flutter + IoT is exactly our stack

---

## Your Financial Commitment at Each Step

```
Today:           $0 — We're just talking
Sprint 0 start:  $850 — PoC (your only commitment)
After PoC:       You decide

If you continue all the way to MVP:

Sprint 0:        $850   (running total: $850)
Sprint 1-2:    $2,380   (running total: $3,230)
Sprint 3-4:    $2,040   (running total: $5,270)
Sprint 5-6:    $2,040   (running total: $7,310)
Sprint 7:        $850   (running total: $8,160)
                         ─────────────────────
                         MVP complete: ~$8,160
```

At every step you have a **working deliverable** and the **choice to stop**.

---

## What You Get for ~$8,160

1. **Complete Flutter app** (iOS + Android) with premium UI
2. **C++ core engine** with MAVLink integration
3. **WiFi + BLE** gimbal communication
4. **Motion recording & playback** with ±0.5° precision
5. **Video motion detection** with auto-trigger
6. **Camera synchronization** via AUX port
7. **Full source code** — you own everything
8. **Architecture documentation** (included as a gift at kickoff)

---

## Next Step

**Sprint 0: $850, 1 week.**

I connect to your T7, build basic control, send you a demo video.  
You evaluate. If it's not what you expected — we shake hands, $850 spent.  
If it is — we continue to Sprint 1.

---

*All estimates are based on actual task decomposition, not guesswork.  
If a sprint takes fewer hours, you pay less. Full transparency.*
