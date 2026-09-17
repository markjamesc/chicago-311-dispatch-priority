# Chicago 311 — Dataset Evaluation Context

Chicago 311 is **Dataset 2 of 3** in the evaluation of the five-stage AI-Augmented Analyst workflow.

Dataset 1, FulfillIQ 2.0, tested the methodology on a relational e-commerce seller-enrollment decision. Chicago 311 tests the same framework on a materially different problem class:

- more than 14.6 million operational records;
- request-level grain;
- open-work triage;
- time-window logic;
- source-scale and delivery constraints;
- ambiguous operational warrant;
- and a three-way request-level action.

## Locked decision class

The project asks one decision only:

> Among open eligible 311 requests in a frozen decision window, which requests should receive `ESCALATE`, `INCONCLUSIVE`, or `STANDARD` dispatch priority?

The final judged universe must contain one row per request.

The action list is a portfolio simulation. It must not be represented as an actual City of Chicago dispatch order or policy recommendation.

## What the project is not

This is not:

- a general study of Chicago 311;
- a neighborhood ranking exercise;
- a city employee or department performance study;
- a live municipal deployment;
- a dashboard project;
- a forecasting competition;
- or a second business decision.

## Evaluation objective

The project is intended to test whether the methodology can:

1. convert an operational request into one defensible decision;
2. freeze analytical meaning before implementation;
3. keep SQL focused on faithful source delivery rather than hidden judgment;
4. independently translate the Stage 3 contract in R-A and R-B;
5. require exact agreement on locked critical fields;
6. perform structural cross-review after agreement;
7. distinguish translation consistency from substantive warrant;
8. and produce a proportionate Stage 5 recommendation from validated evidence.

## Feasibility requirement

The project must explicitly test both **decision feasibility** and **delivery feasibility**. A question that sounds operationally useful but cannot be materially answered from the available source fields should be revised or blocked. Likewise, Stage 3 must define a bounded SQL source package rather than automatically handing all 14.6 million raw rows to R.
