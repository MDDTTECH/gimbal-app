# SPIN SALES SCRIPT — Monday Call with Henry

**Objective:** Close on Sprint 0 ($850 PoC), establish T&M relationship  
**Duration:** 45-60 min  
**Mindset:** Consultant, not salesman. We're solving his problem.

---

## PHASE 1: WARM-UP (5 min)

> "Henry, thanks for making time. Before we dive into the tech — I spent the weekend going deep into the Gremsy T7 SDK, the MAVLink protocol, and the architecture the other team shared. I have a clear picture of what needs to be built. But first — I want to make sure I understand YOUR needs correctly."

---

## PHASE 2: SITUATION QUESTIONS (10 min)

*Goal: Understand his current setup and context*

1. **"Walk me through your current workflow — how are you controlling the gimbal today?"**
   - Listen for: manual control, existing tools, pain points
   
2. **"What camera are you using with the T7? The Sony α7 III?"**
   - Listen for: confirmation, other cameras, lens setup

3. **"How are you triggering shots right now — manually, remote, timer?"**
   - Listen for: current workflow gaps

4. **"You mentioned motion recording — are you doing any kind of repeatable motion today, even manually?"**
   - Listen for: how he's improvising without the tool

5. **"How many different motion sequences do you typically need for a project?"**
   - Listen for: scale (5? 50? 500?)

6. **"Is this for a specific use case — product photography, wildlife, time-lapse, something else?"**
   - Listen for: THE primary use case (this guides prioritization)

---

## PHASE 3: PROBLEM QUESTIONS (10 min)

*Goal: Surface the pain he feels today*

7. **"What's the biggest headache with your current setup?"**
   - Let him talk. Don't solve yet.

8. **"When you need to repeat the same camera movement — how consistent is it manually?"**
   - Expected answer: inconsistent, time-consuming
   - **Amplify:** "So every take is slightly different, and you burn time trying to match it?"

9. **"How much time do you spend per session just getting the motion right?"**
   - Expected: significant time waste
   - **Amplify:** "So if I'm hearing right, the motion itself isn't the hard part — it's the CONSISTENCY and REPEATABILITY?"

10. **"Have you tried any other software solutions? What didn't work?"**
    - Listen for: what he's already rejected and why

11. **"The other team's proposal — what specifically made you look for alternatives?"**
    - Listen for: concerns about their approach (price? timeline? trust? tech?)

---

## PHASE 4: IMPLICATION QUESTIONS (5 min)

*Goal: Make the pain bigger — what happens if he doesn't solve this?*

12. **"What does it cost you when a shoot doesn't come out right because the motion wasn't consistent?"**
    - Money (reshoot costs), Time, Client trust

13. **"If you're spending [X hours] per session on manual adjustments — how many sessions per month?"**
    - Calculate: "So that's [Y hours/month] on something a machine should do in seconds"

14. **"Does the inconsistency ever cause you to lose clients or turn down projects?"**
    - This hits revenue directly

15. **"What happens if you don't solve this in the next 3-6 months? Same workflow?"**
    - Creates urgency

---

## PHASE 5: NEED-PAYOFF QUESTIONS (5 min)

*Goal: Let HIM describe the value of the solution*

16. **"If you could record a perfect camera motion once, and replay it identically every time — how would that change your workflow?"**
    - Let him sell himself

17. **"If the app could automatically trigger the camera AND the gimbal motion when it detects movement — would that open up new types of projects?"**
    - Wildlife, security, automated product photography

18. **"What would it be worth to you if a shoot that takes 2 hours today took 15 minutes?"**
    - Get him to quantify the value (should be >> $8k)

19. **"If you had this tool working reliably in 8 weeks — what project would you use it on first?"**
    - Future-pacing: he's already imagining using it

---

## PHASE 6: SOLUTION PRESENTATION (10 min)

### The Prototype Demo

> "Before I show you the architecture — let me show you something I built this weekend."

**[Show Flutter prototype on phone/simulator]**

> "This is a design prototype of what the app will look like. Obviously it's not connected to a real gimbal yet — but this is the actual interface."

Walk through:
1. **Splash → Auto-connect** (WiFi scanning animation)
2. **Dashboard** — joystick, real-time angles, mode switching
3. **Recording** — tap to record, waveform visualization
4. **Sequences** — saved motions, one-tap playback
5. **Detection** — draw ROI, arm the trigger
6. **Settings** — speed, smoothness, connection config

> "This is the level of polish I deliver. Not a prototype thrown together — a product."

### The Architecture (Hand over spec)

> "I've also prepared an architecture spec as a gift, regardless of whether we work together. It documents every technical decision — protocol, data formats, error handling. If you work with me or someone else, this is useful."

**[Hand over / share ARCHITECTURE_SPEC.md]**

### The Approach

> "Here's how I work — and it's probably different from what you've heard before."

> "I don't do fixed-price on projects like this. Here's why:
> Fixed price means I pad for risks. You pay for things that might not happen.
> 
> Instead — **Time & Materials, short iterations.**
> 
> Every 1-2 weeks:
> - You see a working demo
> - You pay for actual hours worked
> - You decide: continue, adjust, or stop
> 
> You're never locked in."

### The Roadmap

```
Sprint 0: PoC — 1 week, ~$850
  → I connect to YOUR T7, show basic control from the app
  → You evaluate: is this the right team?

Sprint 1-2: Foundation — 2 weeks, ~$2,400
  → Full manual control app (what you just saw, but real)

Sprint 3-4: Recording — 2 weeks, ~$2,000
  → Record and replay sequences

Sprint 5-6: Precision — 2 weeks, ~$2,000
  → ±0.5° accuracy, drift correction

Sprint 7: Detection — 1 week, ~$850
  → Auto-trigger on motion + camera sync

Total MVP: ~$8,100 over 7-8 weeks
```

> "But your commitment right now? Just Sprint 0. $850."

---

## PHASE 7: OBJECTION HANDLING

### "That's cheaper than I expected. Is the quality there?"

> "Fair question. You just saw the prototype — that's the quality bar.
> The hourly rate is competitive because I use AI-assisted development
> for boilerplate code, which lets me focus my expertise on the hard
> parts: MAVLink integration, timing precision, drift correction.
> You're not paying less for less quality — you're paying less because
> I work more efficiently."

### "The other team quoted $20-30k"

> "That's typical for a fixed-price project with risk padding.
> My $8k estimate is T&M — you pay for actual work, not risk buffer.
> And if it takes less time, you pay less. If scope changes, we
> adjust the plan — no change orders, no re-negotiation."

### "I need to think about it"

> "Of course. But here's the thing — Sprint 0 is $850 and takes 1 week.
> If after that week you're not impressed, you're out $850 and you
> have a working demo video you can show to any other developer as
> a reference point. The risk is almost zero."

### "Can you do fixed price?"

> "I could — but it would be $12-15k because I'd need to pad for risks.
> T&M at $8k is the honest number. Fixed price benefits me (guaranteed
> revenue), T&M benefits you (pay only for actual work).
> Which do you prefer?"

### "When can you start?"

> "As soon as the T7 arrives. I can start architecture work and
> the Flutter app immediately. When are you shipping it?"

---

## PHASE 8: CLOSE (5 min)

### The Natural Close

> "So here's what I suggest:
> 
> **Step 1:** You ship the T7 to me.
> **Step 2:** I start Sprint 0 — PoC, 1 week, ~$850.
> **Step 3:** I send you a demo video of the app controlling your gimbal.
> **Step 4:** You decide if we continue.
> 
> Sound good?"

### If Yes:

> "Great. I'll send you an invoice for Sprint 0 today.
> What's the shipping address situation — when can you send the T7?"

### If "Let me think":

> "Totally fine. I'll send you the architecture spec and the sprint
> roadmap by email tonight. Take your time.
> 
> Just know: the $850 PoC has zero lock-in.
> If it doesn't blow you away, we shake hands and walk away."

---

## POST-CALL ACTIONS

- [ ] Send architecture spec (ARCHITECTURE_SPEC.md) within 2 hours
- [ ] Send sprint roadmap summary (clean, not this script)
- [ ] Send Sprint 0 invoice (if agreed)
- [ ] Confirm shipping address for T7
- [ ] Set reminder: follow up in 48h if no response

---

## KEY PHRASES TO REMEMBER

| Moment | Say This |
|--------|----------|
| When showing prototype | "This is the level of polish I deliver" |
| When discussing price | "Fixed price = you pay for my risks. T&M = you pay for my work" |
| When he hesitates | "Your commitment is $850, not $8,000" |
| When comparing to competitors | "Cheaper on paper or cheaper in reality?" |
| When discussing timeline | "8 weeks to MVP, but you evaluate every 2 weeks" |
| When handing spec | "This is yours regardless — even if we don't work together" |

---

## PREPARATION CHECKLIST

- [ ] Flutter prototype running on phone OR simulator recording
- [ ] Architecture spec printed / PDF ready to share
- [ ] Calm, confident energy — we're the experts, not the salespeople
- [ ] Sprint 0 invoice template ready (send within 1 hour of "yes")
- [ ] Screen recording of prototype ready as backup

---

*Remember: He already reached out to YOU. He already has the problem. 
Your job is not to convince him he needs this — it's to show him 
you're the right person to build it.*
