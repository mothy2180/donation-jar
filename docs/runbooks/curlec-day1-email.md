# Day-1 email to Razorpay Curlec (send before writing payment code)

Why: the architecture assumes Curlec Basic + Route, and several facts are
unconfirmed (research of 2026-10-04/05). Keep the written reply with the KYB file
and encode each answer in `app.fee_policies` / the adapter capabilities.

**How to send**: first sign up for a Curlec merchant account (M0 needs the test
keys anyway). Send this through the dashboard's support/ticket channel and also
through the Contact Sales form on curlec.com. Record the ticket or reference
number in PROJECT.md §16.

**Subject**: Route split payments for a donation-transparency platform — pre-integration questions

> Hi Curlec team,
>
> We are building a Malaysian donation-transparency platform. Donors pay by FPX,
> DuitNow Pay and e-wallets; each payment must be split at order creation to the
> verified payee's own Linked Account (the beneficiary organisation or, for an
> individual case, its sponsoring organisation or the hospital). Our balance should
> keep only our fee share. Before integrating we need written confirmation of the
> following:
>
> 1. **Plan**: Is Route (split payments to Linked Accounts) available on the Basic
>    plan (RM0 setup), or only on Premium/Enterprise?
> 2. **Business category**: Is a donation / charity-fundraising platform an
>    accepted business type?
> 3. **Linked Accounts**: What KYC documents are required for a Linked Account that
>    is (a) an SSM-registered organisation or ROS society, (b) a hospital or vendor
>    receiving funds raised for a named patient, (c) an individual
>    (`business_type: individual` / `not_yet_registered`), (d) a registered society
>    or company receiving funds raised for a named individual it sponsors — any
>    restriction? Your KYC page says individual/unregistered businesses are not
>    supported — does that also apply to Linked Accounts? Typical approval time and
>    any per-account limits? Is the Create Linked Account API enabled for us, or
>    Support-only?
> 4. **Route fees**: The exact transfer fee in Malaysia (your docs' example shows
>    0.25%), the settlement cycle for Linked Accounts (docs say 2 working days), and
>    whether transfers can be attached to Orders paid by FPX, DuitNow Pay and
>    e-wallets.
> 5. **SST**: Is 8% service tax added to Curlec's fees in Malaysia? (Your pricing
>    page mentions "18% GST", which looks like an India template.)
> 6. **Refunds**: Are the gateway fee and the Route transfer fee returned on a
>    refund or reversal? Is there a per-refund fee (your FAQ says RM0.50, the refund
>    page says none)? Is `reverse_all=1` supported on Malaysian refunds? Does a
>    negative merchant balance block Route transfers?
> 7. **Settlement holds**: What is the maximum period a Linked Account settlement
>    may be kept `on_hold`, and who legally holds the funds meanwhile?
> 8. **DuitNow Pay**: How do we request early access? Pricing confirmation
>    (1.20%, min RM0.30 on Basic)?
> 9. **Webhooks**: Confirm production IPs (43.216.167.81, 43.216.100.227,
>    43.216.239.250), the 5-second response requirement, the 24-hour retry window
>    and auto-disable behaviour, and that `x-razorpay-event-id` is present on every
>    event.
> 10. **Recurring**: Confirm Subscriptions support only cards and TNG/GrabPay/
>     ShopBack, that Route does not auto-split subscription charges, and any
>     roadmap for DuitNow AutoDebit.
> 11. **Terms**: Please share the Malaysia Route/Linked Account terms and your
>     DPA / data-location statement (where KYC and payment data are processed,
>     including any processing in India).
> 12. **Fee cover**: May donors choose an optional, unticked amount that covers
>     the processing and transfer fees of the payment method they selected? It is
>     computed from that method's rate, so it differs by method (for a RM50 gift
>     about RM1.08 on FPX vs RM0.65 on DuitNow Pay, plus about RM0.13 transfer
>     fee). Do your terms, PayNet FPX/DuitNow rules or Visa/Mastercard rules
>     restrict a method-dependent amount, and if so would one method-independent
>     amount be acceptable?
> 13. **Records**: Under which law, and for how long, do you retain the KYC
>     documents you collect for Linked Accounts? Are you a reporting institution
>     under AMLA 2001?
>
> Our entity for the merchant account will initially be an SSM-registered sole
> proprietorship (Enterprise) for sandbox/KYB, migrating to a Sdn Bhd before live
> donations — please confirm that is acceptable and how re-keying works.
>
> Thank you,
> [Name], [Enterprise name, or "SSM registration submitted on <date>"], [SSM no. when issued], [phone]

Log the date sent, the ticket number and the reply in PROJECT.md §16 (journal).
