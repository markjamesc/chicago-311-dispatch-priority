# Chicago 311 Source Manifest

## Authoritative source

- Dataset: **City of Chicago 311 Service Requests**
- Dataset ID: `v6vf-nfxy`
- Official portal: https://data.cityofchicago.org/Service-Requests/311-Service-Requests/v6vf-nfxy
- Local database schema: `chicago311`
- Authoritative raw table: `raw_311_requests`
- Raw column count: **39**

## Frozen local snapshot

The project uses one complete downloaded CSV snapshot from the official City of Chicago source.

The raw source remains unchanged. Cleaning, filtering, classification, deduplication, and analytical interpretation must occur in later controlled stages.

## Verified import evidence

```text
Imported physical rows:       14,635,395
Distinct SR_NUMBER:            14,635,395
Duplicate SR_NUMBER:                    0
Import skipped rows:                    0
Import deleted rows:                    0
Import warnings:                        0
```

Observed `STATUS` distribution:

```text
Completed              14,177,547
Open                      245,193
Canceled                  212,654
Closed                          1
Total                  14,635,395
```

Date and missingness characterization:

```text
Minimum CREATED_DATE: 2018-07-01 03:42:31
Maximum CREATED_DATE: 2026-09-12 15:39:45
Missing CREATED_DATE:                  0
Unparseable CREATED_DATE:              0
Missing LAST_MODIFIED_DATE:            0
Missing CLOSED_DATE:             245,217
Missing SR_TYPE:                       0
Missing STATUS:                        0
```

## Source identity rule

`SR_NUMBER` was not assumed to be unique in advance. The frozen snapshot was tested and contains exactly one physical row per `SR_NUMBER`. This supports use of `SR_NUMBER` as the request-level reconciliation key for this snapshot only. Any refreshed source must rerun the uniqueness test.

## Provenance rule

Do not commit the multi-gigabyte raw CSV to GitHub. Preserve source provenance through this manifest, import evidence, SQL scripts, validation artifacts, and the controlling orchestration records.
