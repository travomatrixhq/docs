#!/bin/bash

# Scenario 2
cat > scenario-2/1-search.mdx << 'INNER'
---
title: "Step 1: Roundtrip Search"
openapi: "POST /search"
---
Modify the pre-filled search payload to include a `doa` (Date of Arrival) to trigger a roundtrip search. Hit Send and copy the `search_id` and `signature` from the response.
INNER

cat > scenario-2/2-validate.mdx << 'INNER'
---
title: "Step 2: Validate Fare"
openapi: "POST /fare/validate"
---
Paste the `search_id` and `signature` from Step 1 to lock the price. Copy the `fare_token` and `provider` from the response for the next steps.
INNER

cat > scenario-2/3-seatmap.mdx << 'INNER'
---
title: "Step 3: Fetch Seat Map"
openapi: "POST /fare/seatmap"
---
Use your `fare_token` and `provider` to retrieve the interactive seat map. Identify an available seat and copy its `ancillary_token`.
INNER

cat > scenario-2/4-meals.mdx << 'INNER'
---
title: "Step 4: Fetch Meals"
openapi: "POST /fare/meals"
---
Use the same `fare_token` to fetch the meals catalog. Copy the `ancillary_token` of your desired meal.
INNER

cat > scenario-2/5-book.mdx << 'INNER'
---
title: "Step 5: Book with Ancillaries"
openapi: "POST /booking/create"
---
In the booking payload, add an array for `ancillary_tokens` containing the tokens from Steps 3 and 4. The wallet will be atomically debited for both the flight and the extras.
INNER

# Scenario 3
cat > scenario-3/1-search.mdx << 'INNER'
---
title: "Step 1: Family Search"
openapi: "POST /search"
---
Update the payload to include `pax_adult: 1`, `pax_child: 1`, and `pax_infant: 1`. Notice how the `pax_price_breakdown` separates the tax and base fare for each demographic.
INNER

cat > scenario-3/2-validate.mdx << 'INNER'
---
title: "Step 2: Validate Family Fare"
openapi: "POST /fare/validate"
---
In the `pax` object, make sure to explicitly define `adult: 1`, `child: 1`, and `infant: 1` so the provider locks the correct inventory.
INNER

cat > scenario-3/3-book.mdx << 'INNER'
---
title: "Step 3: Book (Infant Logic)"
openapi: "POST /booking/create"
---
Construct the passenger array carefully. Ensure the `dob` mathematically matches the passenger types (e.g., Infant < 2 years, Child < 12 years) to avoid a `DOB_MISMATCH` error.
INNER

# Scenario 4
cat > scenario-4/1-cancel-quote.mdx << 'INNER'
---
title: "Step 1: Cancel Quote"
openapi: "POST /booking/cancel/quote"
---
Enter your `booking_id` to retrieve a cancellation quote. Review the `airline_penalty_paise` and `refund_amount_paise`.
INNER

cat > scenario-4/2-cancel-confirm.mdx << 'INNER'
---
title: "Step 2: Confirm Cancel"
openapi: "POST /booking/cancel/confirm"
---
Confirm the cancellation. This triggers the **Refund Engine**, which automatically credits the refund amount back to your B2B wallet.
INNER

cat > scenario-4/3-wallet-check.mdx << 'INNER'
---
title: "Step 3: Verify Refund"
openapi: "GET /agency/wallet/transactions"
---
Retrieve your transaction ledger using your `agent_id`. You should see a new ledger entry with `"type": "REFUND"`.
INNER

# Scenario 5
cat > scenario-5/1-duplicate.mdx << 'INNER'
---
title: "Step 1: Safe Retries"
openapi: "POST /booking/create"
---
Send a booking request with a unique `Idempotency-Key`. Once successful, send the exact same request again. Notice that the server returns the identical booking response without debiting your wallet a second time.
INNER

cat > scenario-5/2-conflict.mdx << 'INNER'
---
title: "Step 2: Key Conflict"
openapi: "POST /booking/create"
---
Keep the same `Idempotency-Key` from Step 1, but modify the payload (e.g., change a passenger name). You should receive a `409 Conflict` error, preventing you from accidentally re-using keys for different intents.
INNER

cat > scenario-5/3-insufficient.mdx << 'INNER'
---
title: "Step 3: Insufficient Funds"
openapi: "POST /booking/create"
---
Attempt to book an expensive flight with a test wallet that has $0 balance. You will receive a `402 Payment Required` (INSUFFICIENT_FUNDS) error.
INNER

# Scenario 6
cat > scenario-6/1-search-new.mdx << 'INNER'
---
title: "Step 1: Find New Flight"
openapi: "POST /search"
---
Perform a search for the new desired travel date. Copy the `offer_id` of the flight you wish to switch to.
INNER

cat > scenario-6/2-reschedule-quote.mdx << 'INNER'
---
title: "Step 2: Reschedule Quote"
openapi: "POST /booking/reschedule/quote"
---
Provide your `booking_id` and the `new_offer_id`. The system calculates the `fare_difference_paise` and any `change_penalty_paise`.
INNER

cat > scenario-6/3-reschedule-confirm.mdx << 'INNER'
---
title: "Step 3: Confirm Change"
openapi: "POST /booking/reschedule/confirm"
---
Finalize the reschedule. The wallet will be automatically debited for the fare difference and penalty fees.
INNER

# Scenario 7
cat > scenario-7/1-partial-quote.mdx << 'INNER'
---
title: "Step 1: Partial Cancel Quote"
openapi: "POST /booking/partial-cancel/quote"
---
Provide a `booking_id` that has multiple passengers. Add the target passenger's ID (e.g., `ADT2`) to the `passengers_to_cancel` array to get a quote.
INNER

cat > scenario-7/2-partial-confirm.mdx << 'INNER'
---
title: "Step 2: Confirm Split"
openapi: "POST /booking/partial-cancel/confirm"
---
Confirm the cancellation. The system will handle the PNR Splitting logic with the airline, leaving the remaining passengers in a `TICKETED` state.
INNER

# Scenario 8
cat > scenario-8/1-create-user.mdx << 'INNER'
---
title: "Step 1: Create Finance User"
openapi: "POST /agency/users"
---
Create a new user assigned to the `FINANCE` role. This role allows managing wallets but restricts flight booking operations.
INNER

cat > scenario-8/2-ledger.mdx << 'INNER'
---
title: "Step 2: Audit Ledger"
openapi: "GET /agency/wallet/transactions"
---
Retrieve the immutable transaction ledger to audit all `DEBIT`, `CREDIT`, and `REFUND` movements.
INNER

# Scenario 9
cat > scenario-9/1-pagination.mdx << 'INNER'
---
title: "Step 1: Pagination"
openapi: "POST /search"
---
Execute a search. Take the `cursor` string from the response, and submit a new search request with ONLY the `cursor` field populated to fetch the next page of results.
INNER

cat > scenario-9/2-autocomplete.mdx << 'INNER'
---
title: "Step 2: Airport Autocomplete"
openapi: "GET /airports"
---
Pass a query like `q=Lond` to retrieve a standardized list of IATA airport codes for your frontend UI.
INNER

