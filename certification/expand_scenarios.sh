#!/bin/bash

# --- SCENARIO 4: Cancellations ---
cat > scenario-4/1-search.mdx << 'INNER'
---
title: "Step 1: Search Flights"
openapi: "POST /search"
---
To test cancellations, we first need a booking. Start by searching for a flight.
Copy the `search_id` and `signature` from the response.
INNER

cat > scenario-4/2-validate.mdx << 'INNER'
---
title: "Step 2: Validate Fare"
openapi: "POST /fare/validate"
---
Paste your `search_id` and `signature` to lock the price. Copy the resulting `fare_token`.
INNER

cat > scenario-4/3-book.mdx << 'INNER'
---
title: "Step 3: Create Booking"
openapi: "POST /booking/create"
---
Paste your `fare_token` and execute the booking to generate a PNR. Copy the `booking_id`.
INNER

cat > scenario-4/4-ticket.mdx << 'INNER'
---
title: "Step 4: Issue Ticket"
openapi: "POST /booking/ticket"
---
Issue the ticket for your `booking_id`. A booking must be `TICKETED` before it can be cancelled.
INNER

mv scenario-4/1-cancel-quote.mdx scenario-4/5-cancel-quote.mdx
mv scenario-4/2-cancel-confirm.mdx scenario-4/6-cancel-confirm.mdx
mv scenario-4/3-wallet-check.mdx scenario-4/7-wallet-check.mdx

# --- SCENARIO 6: Reschedule ---
cat > scenario-6/1-search.mdx << 'INNER'
---
title: "Step 1: Initial Search"
openapi: "POST /search"
---
Search for your original flight.
INNER

cat > scenario-6/2-validate.mdx << 'INNER'
---
title: "Step 2: Validate Fare"
openapi: "POST /fare/validate"
---
Lock the price of the original flight.
INNER

cat > scenario-6/3-book.mdx << 'INNER'
---
title: "Step 3: Create Booking"
openapi: "POST /booking/create"
---
Book the original flight and copy the `booking_id`.
INNER

cat > scenario-6/4-ticket.mdx << 'INNER'
---
title: "Step 4: Issue Ticket"
openapi: "POST /booking/ticket"
---
Issue the ticket. You can only reschedule a `TICKETED` booking.
INNER

mv scenario-6/1-search-new.mdx scenario-6/5-search-new.mdx
mv scenario-6/2-reschedule-quote.mdx scenario-6/6-reschedule-quote.mdx
mv scenario-6/3-reschedule-confirm.mdx scenario-6/7-reschedule-confirm.mdx

# --- SCENARIO 7: Partial Cancel ---
cat > scenario-7/1-search.mdx << 'INNER'
---
title: "Step 1: Multi-Pax Search"
openapi: "POST /search"
---
To test partial cancellations, you must search for a flight with at least 2 passengers (e.g., `pax_adult: 2`).
INNER

cat > scenario-7/2-validate.mdx << 'INNER'
---
title: "Step 2: Validate Fare"
openapi: "POST /fare/validate"
---
Ensure you set `adult: 2` in your validation payload.
INNER

cat > scenario-7/3-book.mdx << 'INNER'
---
title: "Step 3: Create Booking"
openapi: "POST /booking/create"
---
Provide two distinct passengers in the `passengers` array (e.g., `ADT1` and `ADT2`). Copy the `booking_id`.
INNER

cat > scenario-7/4-ticket.mdx << 'INNER'
---
title: "Step 4: Issue Ticket"
openapi: "POST /booking/ticket"
---
Issue the tickets.
INNER

mv scenario-7/1-partial-quote.mdx scenario-7/5-partial-quote.mdx
mv scenario-7/2-partial-confirm.mdx scenario-7/6-partial-confirm.mdx

# --- SCENARIO 5: Idempotency ---
cat > scenario-5/1-search.mdx << 'INNER'
---
title: "Step 1: Search Flights"
openapi: "POST /search"
---
Search for a flight.
INNER

cat > scenario-5/2-validate.mdx << 'INNER'
---
title: "Step 2: Validate Fare"
openapi: "POST /fare/validate"
---
Lock the price.
INNER

mv scenario-5/1-duplicate.mdx scenario-5/3-duplicate.mdx
mv scenario-5/2-conflict.mdx scenario-5/4-conflict.mdx
mv scenario-5/3-insufficient.mdx scenario-5/5-insufficient.mdx

