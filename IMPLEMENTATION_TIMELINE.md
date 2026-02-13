# GIMBAL CONTROL APP — Implementation Timeline

**Prepared for:** Henry  
**Date:** February 14, 2026  
**Model:** Time & Materials, sprint-based  

---

## Overview

```
Week  0   1   2   3   4   5   6   7   8   9  10
      │   │   │   │   │   │   │   │   │   │   │
      ├───┤   │   │   │   │   │   │   │   │   │
      PoC │   │   │   │   │   │   │   │   │   │
      ✓   ├───┴───┤   │   │   │   │   │   │   │
          Foundation   │   │   │   │   │   │   │
          ✓            ├───┴───┤   │   │   │   │
                       Recording   │   │   │   │
                       ✓           ├───┴───┤   │
                                   Precision   │
                                   ✓           ├───┤
                                            Detection
                                               ✓ MVP DONE
                                                       
                                               Optional:
                                               ├───┴───┤
                                               Cloud MVP+
```

**Total MVP:** 7–8 weeks | **Each sprint ends with a decision point.**

---

## Sprint 0 — Proof of Concept

**Duration:** 1 week  
**Goal:** Validate WiFi communication + basic gimbal control from phone

| Day | Task | Hours |
|-----|------|-------|
| Mon | Gremsy T7 SDK study, MAVLink protocol deep-dive | 4h |
| Tue | WiFi connection to gimbal (10.10.10.254, UDP) | 6h |
| Wed | MAVLink HEARTBEAT exchange, basic command send | 4h |
| Thu | Implement pan/tilt control commands, receive feedback | 4h |
| Fri | Flutter demo app — connect + control + record demo video | 5h |
| Fri | Demo video preparation & delivery | 2h |

**Deliverable:** Video showing app controlling gimbal via WiFi  
**Success criteria:**
- App connects to T7 reliably
- Commands execute within 100ms
- No dropped packets over 10-minute session

**Decision point:** Continue → Sprint 1-2 | Stop → you're out ~$850

---

## Sprint 1–2 — Core Foundation

**Duration:** 2 weeks  
**Goal:** Production-quality architecture + full manual control

### Week 1 — Architecture & MAVLink

| Task | Hours |
|------|-------|
| C++ project structure + CMake setup | 4h |
| Flutter project architecture + state management (Riverpod) | 4h |
| FFI bridge: Dart ↔ C++ communication layer | 4h |
| MAVLink command queue with retry logic | 6h |
| Connection error handling (disconnect, timeout, reconnect) | 6h |
| WiFi/BLE connection manager | 4h |
| Unit tests for communication layer | 7h |

### Week 2 — Manual Control UI

| Task | Hours |
|------|-------|
| Joystick control widget (pan/tilt) | 8h |
| Angle sliders (pan/tilt/roll) with real-time feedback | 6h |
| Gimbal status display (angles, battery, signal, mode) | 6h |
| Mode switching (Follow / Lock / FPV) | 4h |
| State management wiring | 6h |
| Integration testing + polish | 5h |

**Deliverable:** Fully functional manual control app  
**Success criteria:**
- Joystick + sliders control gimbal smoothly
- Real-time angle feedback displayed
- Auto-reconnect on connection loss
- Mode switching works

**Decision point:** Continue → Sprint 3-4 | Adjust scope | Stop

---

## Sprint 3–4 — Motion Recording

**Duration:** 2 weeks  
**Goal:** Record gimbal movements and play them back

### Week 3 — Recording Engine

| Task | Hours |
|------|-------|
| Position capture at 10 Hz (pan/tilt/roll + timestamp) | 6h |
| Microsecond timestamp management | 6h |
| SQLite storage: save/load motion sequences | 6h |
| Recording UI (start/stop, timer, point counter) | 8h |
| Basic playback (send recorded points sequentially) | 9h |

### Week 4 — Playback & Management

| Task | Hours |
|------|-------|
| Playback improvements (speed control, pause/resume) | 12h |
| Sequence management UI (list, rename, delete, favorite) | 8h |
| Testing & debugging | 5h |

**Deliverable:** Record & replay motion sequences  
**Success criteria:**
- Record 30-second sequence with 300+ points
- Playback roughly follows recorded path (±2° accuracy)
- Store 10+ sequences, persistent across app restarts

**Decision point:** Continue → Sprint 5-6 | Adjust scope | Stop

---

## Sprint 5–6 — Precision Playback

**Duration:** 2 weeks  
**Goal:** Deterministic, repeatable motion with sub-degree accuracy

### Week 5 — Interpolation & Timing

| Task | Hours |
|------|-------|
| Cubic spline interpolation between recorded points | 12h |
| Firmware clock synchronization | 10h |
| Command buffering (send 5-10 points ahead) | 8h |
| Integration testing | 5h |

### Week 6 — Drift Correction

| Task | Hours |
|------|-------|
| Drift detection (compare actual vs expected position) | 10h |
| Correction algorithm (adjust remaining commands) | 10h |
| 50× playback repeatability testing | 10h |
| Bug fixes & edge cases | 5h |

**Deliverable:** High-precision repeatable playback  
**Success criteria:**
- ±0.5° accuracy after 50 consecutive playbacks
- No drift accumulation over 5-minute sequences
- Survives app backgrounding for 10 seconds

**Decision point:** Continue → Sprint 7 | Adjust scope | Stop

---

## Sprint 7 — Motion Detection & Camera Trigger

**Duration:** 1 week  
**Goal:** Auto-trigger gimbal playback on detected motion + camera sync

| Task | Hours |
|------|-------|
| Frame differencing algorithm (OpenCV or native) | 8h |
| Motion detection in user-selected ROI | 6h |
| ROI selection UI (draw rectangle on camera preview) | 4h |
| Camera trigger via AUX port | 5h |
| Integration testing (detect → trigger → playback → camera) | 2h |

**Deliverable:** Automatic trigger system  
**Success criteria:**
- Detect person/object entering frame within 500ms
- False positive rate < 5%
- Camera triggers within 50ms of designated sequence point
- End-to-end: motion → gimbal moves → camera fires

**MVP COMPLETE**

---

## Sprint 8–9 — Cloud Features (MVP+, Optional)

**Duration:** 2 weeks  
**Goal:** User accounts, video upload, cross-device sync

### Week 8 — Backend

| Task | Hours |
|------|-------|
| Node.js REST API | 16h |
| Firebase Authentication (Google/Email) | 8h |
| PostgreSQL schema (users, sequences, videos) | 6h |

### Week 9 — Cloud Storage & Sync

| Task | Hours |
|------|-------|
| Chunked video upload to S3 (resumable) | 12h |
| Cross-device sequence sync | 10h |
| End-to-end testing | 8h |

**Deliverable:** Cloud-connected app  
**Decision:** Continue with additional features or wrap up

---

## Key Milestones Summary

| Week | Milestone | You Can... |
|------|-----------|------------|
| **0** | PoC demo video | See the app control your gimbal |
| **2** | Manual control app | Use the app daily for manual work |
| **4** | Motion recording | Record and replay sequences |
| **6** | Precision playback | Run automated, repeatable shots |
| **7** | **MVP complete** | Full automated workflow with camera |
| **9** | Cloud sync (optional) | Access sequences from any device |

---

*Every sprint ends with a working deliverable and your decision whether to continue.*
