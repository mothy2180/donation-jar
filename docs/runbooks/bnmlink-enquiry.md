# BNMLINK enquiry (only before enabling any settlement-hold / payout-on-proof feature)

Channel: https://bnmlink.bnm.gov.my/?lang=en&type=enquiry · phone 1300-88-5465
(Mon–Fri 9am–5pm). Fintech-specific queries: Financial Technology Enabler Group
(FTEG), https://www.myfteg.com/. Keep the written reply with the KYB file.

> Where a BNM-registered merchant acquirer (Razorpay Curlec Sdn Bhd) receives each
> donation and settles the payee's share only to the payee's own Linked Account,
> but our platform instructs when that settlement is released (the platform's own
> Curlec merchant account receives each payment and normally holds it only until
> Curlec's automatic split, and keeps only its disclosed platform fee, fee covers
> and tips plus a self-funded refund float; if an automatic transfer fails, the
> payee's share stays in that merchant balance for at most 24 hours of automatic
> retries and is then refunded to the donor, and refunds are paid from that
> balance after the payee's share is reversed into it; it creates no
> donor-redeemable balance), does Bank Negara Malaysia
> regard the platform as (i) issuing electronic money under s.11 FSA 2013,
> (ii) providing merchant acquiring services or acting as a payment facilitator
> under s.17 and the Merchant Acquiring Services Policy Document para 2.1, or
> (iii) neither — and is there a maximum period for which such settlements may be
> withheld?

Context for the MVP: no holds are used; every transfer is `on_hold: false`.
