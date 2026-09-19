Model: ChatGPT Chat (highest reasoning)
## 1. Proposed final analytical question (ONE primary question)

Among open eligible 311 requests in the frozen decision window, which requests should receive ESCALATE, which INCONCLUSIVE, and which STANDARD dispatch priority so limited shift attention can focus on unresolved requests that deserve elevation while uncertain cases are held separately, under portfolio-simulation rules (not live City dispatch, not employee scoring, and without inventing an official City SLA)? 

---

## 2. One-sentence decision linkage to the locked Start

This question directly operationalizes the locked Start decision: assign one portfolio-simulation outcome (ESCALATE / INCONCLUSIVE / STANDARD) to each open eligible 311 request in a frozen decision window, without redefining the decision as ranking, live dispatch, employee scoring, or official SLA enforcement. 

---

## 3. Stakeholder statements supporting each clause (cite Turn IDs)

### Clause: “Among open eligible 311 requests”

* **Support:** Dana defined **open** as unresolved/not closed at the frozen cutoff and **eligible** as in-scope for the portfolio run, while leaving exact rules for later measurement design.
* **Evidence:** T012: “Open means still unresolved — not closed — at the frozen cutoff. Eligible means it’s in scope for this portfolio run… Exact open and eligibility rules are measurement-design work.” 

### Clause: “in the frozen decision window”

* **Support:** Dana rejected a live feed and confirmed the analysis should use a stable frozen snapshot; exact calendar dates remain deferred.
* **Evidence:** T006: “I just need the analysis to use one frozen window, not a live ticker.” 

### Clause: “which requests should receive ESCALATE, which INCONCLUSIVE, and which STANDARD”

* **Support:** Dana confirmed three outcomes: elevate, cannot classify, or standard/normal queue, and later locked the portfolio labels ESCALATE, INCONCLUSIVE, and STANDARD.
* **Evidence:** T004 established the three outcomes. 
* **Evidence:** T010 locked the labels: “you can use ESCALATE, INCONCLUSIVE, and STANDARD for elevate / cannot-classify / standard.” 

### Clause: “so limited shift attention can focus on unresolved requests that deserve elevation while uncertain cases are held separately”

* **Support:** Dana’s original operational need was identifying unresolved requests needing attention rather than allowing important requests to remain in the normal queue; she also explicitly required a holding category for uncertain cases.
* **Evidence:** T000: “I need help figuring out which of our currently unresolved 311 requests need attention this period.” 
* **Evidence:** T004: “Don’t force those into elevated or normal just to fill a spreadsheet.” 

### Clause: “under portfolio-simulation rules”

* **Support:** Dana confirmed this is a simulation rather than an actual City dispatch process.
* **Evidence:** T008: “Correct — portfolio simulation only. Do not treat an ‘elevate’ label as an actual City dispatch order…” 

### Clause: “not live City dispatch, not employee scoring”

* **Support:** Dana explicitly excluded both.
* **Evidence:** T008: “Do not treat an ‘elevate’ label as an actual City dispatch order, and do not score employees.” 

### Clause: “without inventing an official City SLA”

* **Support:** Dana prohibited treating any urgency rule as an official municipal SLA.
* **Evidence:** T008: “Also: don't invent an official City SLA as if we pulled it from policy.” 

---

## 4. Explicit working assumptions (must remain Stage 3 / open — not locked in the question)

* Exact frozen decision-window dates remain open.
* Exact open-request rules remain open.
* Exact eligibility rules remain open.
* Any urgency rule or classification logic remains open.
* Any measurement definitions, metrics, thresholds, SQL design, R implementation, or formulas remain open.
* Capacity constraints, ranking, or shortlisting within ESCALATE remain open later design items and are not part of the analytical question. 
* No official City SLA should be assumed or created. 

---

## 5. The one remaining weakness, if any

The remaining weakness is that the analytical question depends on later Stage 3 definitions for how “open,” “eligible,” and classification logic will be operationalized. This is intentional and does not weaken the Framing question because those details were explicitly deferred rather than prematurely locked. 

---

## 6. Keep, Tighten, or Branch decision

**Decision: Keep coordinator CQ-F01 wording.**

Reason:

* The wording preserves the locked Start.
* It captures the three-way classification requirement.
* It keeps portfolio simulation boundaries explicit.
* It does not introduce Stage 3 metrics, formulas, SQL, R, thresholds, or urgency rules.
* It does not redefine the decision as a ranked shortlist.  

**No revised wording required.**
