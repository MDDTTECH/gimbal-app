# GIMBAL CONTROL APP — Architecture Specification

**Document for:** Henry  
**Prepared by:** IT Studio  
**Date:** February 14, 2026  
**Status:** Pre-development handoff document  

---

## 1. System Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                      MOBILE APP (Flutter)                        │
│                                                                  │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────────────┐ │
│  │   UI Layer  │  │  State Mgmt  │  │   Platform Channels     │ │
│  │   (Dart)    │◄►│  (Riverpod)  │◄►│   (FFI Bridge)          │ │
│  └────────────┘  └──────────────┘  └────────────┬─────────────┘ │
│                                                  │               │
│  ┌───────────────────────────────────────────────▼─────────────┐ │
│  │                   C++ CORE ENGINE                           │ │
│  │  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │ │
│  │  │ MAVLink Comms   │  │ Motion Engine  │  │ Storage      │  │ │
│  │  │ - WiFi (UDP)    │  │ - Record       │  │ - SQLite     │  │ │
│  │  │ - BLE fallback  │  │ - Playback     │  │ - Sequences  │  │ │
│  │  │ - Auto-reconnect│  │ - Interpolation│  │ - Settings   │  │ │
│  │  └───────┬────────┘  └───────┬────────┘  └──────────────┘  │ │
│  └──────────┼──────────────────┼──────────────────────────────┘ │
└─────────────┼──────────────────┼────────────────────────────────┘
              │                  │
    WiFi (UDP) / BLE             │ Sends commands
              │                  │
┌─────────────▼──────────────────▼────────────────────────────────┐
│                       GREMSY T7 GIMBAL                          │
│  ┌──────────────┐  ┌───────────────┐  ┌──────────────────────┐  │
│  │ WiFi Module   │  │ MAVLink v2    │  │ Motor Controller     │  │
│  │ 10.10.10.254  │  │ Parser        │  │ PID @ 2000 Hz        │  │
│  └──────────────┘  └───────────────┘  └──────────┬───────────┘  │
└──────────────────────────────────────────────────┼──────────────┘
                                                   │
                                          ┌────────▼────────┐
                                          │   CAMERA         │
                                          │   Sony α7 III    │
                                          │   (AUX trigger)  │
                                          └─────────────────┘
```

---

## 2. Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **UI Framework** | Flutter 3.x (Dart) | Single codebase iOS + Android, native performance, FFI support |
| **State Management** | Riverpod | Compile-safe, testable, async-first |
| **Core Engine** | C++ 17 via FFI | MAVLink compatibility, microsecond timing, shared across platforms |
| **Protocol** | MAVLink v2 | Industry standard, official Gremsy SDK uses it |
| **Transport (Primary)** | WiFi — UDP to 10.10.10.254 | Stable, high bandwidth, works on both platforms |
| **Transport (Fallback)** | Bluetooth Low Energy | Doesn't require network switch, lower latency for quick adjustments |
| **Local Storage** | SQLite (via C++) | Motion sequences, settings, offline-first |
| **Motion Detection** | Frame Differencing → OpenCV | MVP starts simple, upgrades as needed |
| **Backend (MVP+)** | Node.js + PostgreSQL | REST API for sync, user accounts |
| **Cloud Storage (MVP+)** | AWS S3 (chunked upload) | Resumable uploads, cost-effective at scale |
| **Auth (MVP+)** | Firebase Auth | Google/Email, battle-tested, fast to implement |

---

## 3. Responsibility Split: App vs Firmware

### Firmware (Gremsy T7) owns:
- Motor execution (PID loops at 2000 Hz)
- Real-time timing precision
- Safety limits and emergency stops
- Encoder feedback (actual position)
- State persistence (survives app disconnect)

### App owns:
- User interface and interaction
- High-level motion orchestration
- Recording user movements at 10 Hz
- Sending timestamped commands to firmware
- Motion sequence storage and management
- Video motion detection logic
- Cloud synchronization (MVP+)

**Key principle:** If the app crashes or goes to background, the firmware continues executing the last buffered commands. The app can reconnect and query current gimbal state.

---

## 4. Communication Protocol

### 4.1 Connection Flow

```
App Start
  │
  ├─ Scan for Gremsy WiFi SSID ("Gremsy WiFi")
  │   ├─ Found → Connect to 10.10.10.254:14550 (UDP)
  │   │         → Exchange HEARTBEAT (1 Hz)
  │   │         → Connection established ✓
  │   │
  │   └─ Not found → Try BLE scan
  │                 → Discover "Gremsy T7" service
  │                 → Connect via BLE GATT
  │                 → Fallback mode ✓
  │
  └─ Neither found → Show "No gimbal detected" UI
```

### 4.2 MAVLink Messages Used

| Message | ID | Direction | Purpose |
|---------|----|-----------|---------|
| `HEARTBEAT` | #0 | Both | Keep-alive, 1 Hz |
| `SYS_STATUS` | #1 | Gimbal → App | Battery, errors |
| `COMMAND_LONG` | #76 | App → Gimbal | Mount control commands |
| `MOUNT_ORIENTATION` | #265 | Gimbal → App | Current angles (feedback) |
| `MOUNT_CONFIGURE` | #156 | App → Gimbal | Set mount mode |
| `DO_MOUNT_CONTROL` | #205 | App → Gimbal | Set target angles |
| `RAW_IMU` | #27 | Gimbal → App | Raw sensor data (optional) |

### 4.3 Command Flow (Playback)

```
App                             Gimbal
 │                                │
 │── MOUNT_CONFIGURE (mode) ────►│  Set MAVLink targeting mode
 │                                │
 │── DO_MOUNT_CONTROL ─────────►│  Point 1: pan=0°, tilt=0°
 │── DO_MOUNT_CONTROL ─────────►│  Point 2: pan=5°, tilt=-2°
 │── DO_MOUNT_CONTROL ─────────►│  Point 3: pan=10°, tilt=-4°
 │── DO_MOUNT_CONTROL ─────────►│  ... (buffer 5-10 ahead)
 │                                │
 │◄── MOUNT_ORIENTATION ────────│  Actual: pan=4.8°, tilt=-1.9°
 │                                │
 │  [Compare actual vs expected]  │
 │  [Adjust if drift > 0.5°]     │
 │                                │
 │── DO_MOUNT_CONTROL ─────────►│  Continue buffering...
```

---

## 5. Motion Recording & Playback

### 5.1 Recording Format

```
MotionSequence:
  ├─ id: UUID
  ├─ name: string
  ├─ created_at: timestamp
  ├─ duration_ms: uint64
  ├─ sample_rate_hz: 10
  └─ points[]:
       ├─ timestamp_us: uint64 (microseconds from start)
       ├─ pan: float32 (degrees, -180 to 180)
       ├─ tilt: float32 (degrees, -90 to 90)
       ├─ roll: float32 (degrees, -180 to 180)
       └─ flags: uint8 (camera trigger, etc.)
```

### 5.2 Playback Strategy

1. **Load sequence** from SQLite into memory
2. **Interpolate** using cubic spline between recorded points (smooth)
3. **Sync clocks** — query gimbal device time, calculate offset
4. **Buffer commands** — send next 5-10 points ahead of current time
5. **Monitor feedback** — read `MOUNT_ORIENTATION` every 100ms
6. **Correct drift** — if actual vs expected > 0.5°, adjust remaining points
7. **Repeat** — fill buffer as points execute, until sequence completes

**Target accuracy:** ±0.5° after 50 consecutive playbacks (no drift accumulation).

---

## 6. Video Motion Detection (MVP)

### Approach: Frame Differencing

```
Frame N          Frame N+1         Difference
┌──────────┐    ┌──────────┐    ┌──────────┐
│          │    │    ██    │    │    ██    │  ← Changed pixels
│          │ →  │   ████   │ →  │   ████   │
│          │    │    ██    │    │    ██    │
│  [ROI]   │    │  [ROI]   │    │  [ROI]   │
└──────────┘    └──────────┘    └──────────┘
                                      │
                                Changed > 5% of ROI?
                                      │
                                 YES → Trigger playback
```

**Input:** Phone camera pointed at camera's LCD screen (MVP approach)  
**Processing:** Convert ROI to grayscale → absolute difference → threshold → count pixels  
**Trigger:** If changed pixel ratio exceeds sensitivity threshold → start playback  
**Latency target:** < 500ms from motion to gimbal response  

---

## 7. Project Structure

```
gimbal_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── theme/                       # Design system
│   │   ├── app_theme.dart           # Colors, typography, gradients
│   │   └── glass_morphism.dart      # Glass container components
│   ├── screens/                     # Full-page screens
│   │   ├── splash_screen.dart       # Connect animation
│   │   ├── dashboard_screen.dart    # Main control (joystick + gauges)
│   │   ├── recording_screen.dart    # Motion recording UI
│   │   ├── sequences_screen.dart    # Saved sequences list
│   │   ├── detection_screen.dart    # Camera + ROI + motion detect
│   │   └── settings_screen.dart     # Configuration
│   ├── widgets/                     # Reusable components
│   │   ├── joystick_widget.dart     # Custom joystick control
│   │   ├── gimbal_3d_indicator.dart # 3D orientation display
│   │   ├── angle_display.dart       # Angle gauges + sliders
│   │   ├── status_bar.dart          # Connection + battery bar
│   │   ├── bottom_nav.dart          # Glass navigation bar
│   │   └── animated_background.dart # Floating orb background
│   └── models/
│       └── mock_data.dart           # Prototype mock data
├── cpp/                             # (Sprint 0+) C++ core
│   ├── gimbal_interface.h/cpp       # MAVLink communication
│   ├── motion_engine.h/cpp          # Recording + playback
│   └── CMakeLists.txt               # Build configuration
└── pubspec.yaml                     # Dependencies
```

---

## 8. Sprint Roadmap (MVP)

```
SPRINT 0 ──── PoC (1 week, ~$850)
  │  WiFi connection + basic pan/tilt control + demo video
  │
  ▼  ✓ Decision point
SPRINT 1-2 ── Foundation (2 weeks, ~$2,400)
  │  Full architecture + manual control app + joystick + status
  │
  ▼  ✓ Decision point
SPRINT 3-4 ── Recording (2 weeks, ~$2,000)
  │  Record & replay sequences + SQLite storage + management UI
  │
  ▼  ✓ Decision point
SPRINT 5-6 ── Precision (2 weeks, ~$2,000)
  │  Spline interpolation + drift correction + ±0.5° accuracy
  │
  ▼  ✓ Decision point
SPRINT 7 ──── Detection + Camera (1 week, ~$850)
  │  Motion detection + camera trigger + auto-playback
  │
  ▼  MVP COMPLETE (~$8,100 total)

SPRINT 8-9 ── Cloud MVP+ (2 weeks, ~$2,000) [optional]
       User accounts + video upload + cross-device sync
```

**Model:** Time & Materials, weekly invoicing.  
**Commitment:** Per-sprint only. Stop or adjust at any decision point.

---

## 9. Non-Functional Requirements

| Requirement | Target |
|-------------|--------|
| **Connection latency** | < 100ms command-to-execution |
| **Playback accuracy** | ±0.5° after 50 repetitions |
| **Recording rate** | 10 Hz (100ms between samples) |
| **App crash recovery** | Reconnect within 3 seconds |
| **Battery monitoring** | Real-time, alert at 15% |
| **Sequence storage** | 1000+ sequences locally |
| **Motion detect latency** | < 500ms from detection to trigger |
| **Supported platforms** | iOS 15+ / Android 10+ |

---

## 10. Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| WiFi drops during playback | Auto-reconnect + BLE fallback + firmware continues buffered commands |
| Timing drift | Firmware clock sync + encoder feedback + correction algorithm |
| iOS background suspend | Background audio/location session to maintain connection |
| Camera API unavailable | Phone camera → LCD screen approach for MVP |
| Gimbal firmware bugs | Test on latest firmware, fallback command modes, report to Gremsy |

---

**This document is provided as a complimentary deliverable at project kickoff.**  
**It serves as the technical foundation for all development sprints.**

*IT Studio — February 2026*
