-- 1. Executive Financial Overview & KPI Summary
SELECT 
    COUNT(c.claim_id) AS total_claims,
    SUM(c.billed_amount) AS total_billed,
    SUM(c.allowed_amount) AS total_allowed,
    SUM(c.paid_amount) AS total_paid,
    ROUND(SUM(c.paid_amount) / SUM(c.allowed_amount) * 100, 2) AS net_collection_rate_pct,
    COUNT(CASE WHEN c.claim_status = 'Denied' THEN 1 END) AS total_denied_claims,
    SUM(CASE WHEN c.claim_status = 'Denied' THEN c.billed_amount ELSE 0 END) AS denied_revenue_exposure
FROM claims c;

-- 2. Payer Financial Performance & Collection Rates
SELECT 
    p.insurance_type,
    COUNT(c.claim_id) AS total_claims,
    SUM(c.billed_amount) AS total_billed,
    SUM(c.allowed_amount) AS total_allowed,
    SUM(c.paid_amount) AS total_paid,
    ROUND(AVG(c.paid_amount / NULLIF(c.allowed_amount, 0)) * 100, 2) AS avg_collection_rate_pct
FROM claims c
JOIN payers p ON c.payer_id = p.payer_id
GROUP BY p.insurance_type
ORDER BY total_billed DESC;

-- 3. Top High-Risk Providers Ranked by Denied Revenue
WITH provider_denials AS (
    SELECT 
        c.provider_id,
        COUNT(c.claim_id) AS total_claims,
        COUNT(CASE WHEN c.claim_status = 'Denied' THEN 1 END) AS denied_claims,
        SUM(CASE WHEN c.claim_status = 'Denied' THEN c.billed_amount ELSE 0 END) AS denied_revenue,
        ROUND(
            COUNT(CASE WHEN c.claim_status = 'Denied' THEN 1 END)::NUMERIC / 
            COUNT(c.claim_id) * 100, 2
        ) AS denial_rate_pct
    FROM claims c
    GROUP BY c.provider_id
)
SELECT 
    DENSE_RANK() OVER (ORDER BY denied_revenue DESC) AS denial_rank,
    provider_id,
    total_claims,
    denied_claims,
    denied_revenue,
    denial_rate_pct
FROM provider_denials
WHERE denied_claims > 0
ORDER BY denial_rank
LIMIT 10;

-- 4. Root-Cause Denial Analysis with Part-to-Whole Percentage
WITH denial_summary AS (
    SELECT 
        COALESCE(reason_code, 'Unspecified / Clean') AS reason_code,
        COUNT(claim_id) AS denied_claim_count,
        SUM(billed_amount) AS total_denied_dollars
    FROM claims
    WHERE claim_status = 'Denied'
    GROUP BY reason_code
)
SELECT 
    reason_code,
    denied_claim_count,
    total_denied_dollars,
    ROUND(
        (total_denied_dollars / SUM(total_denied_dollars) OVER()) * 100, 2
    ) AS pct_of_total_denied_revenue
FROM denial_summary
ORDER BY total_denied_dollars DESC;

-- 5. AR Aging Bucket Analysis & Uncollected Revenue Exposure
SELECT 
    ar_status,
    COUNT(claim_id) AS total_claims,
    SUM(billed_amount) AS total_billed,
    SUM(allowed_amount - paid_amount) AS outstanding_balance,
    ROUND(
        SUM(allowed_amount - paid_amount) / SUM(SUM(allowed_amount - paid_amount)) OVER() * 100, 2
    ) AS pct_of_outstanding_ar
FROM claims
WHERE ar_status != 'Closed'
GROUP BY ar_status
ORDER BY outstanding_balance DESC;

























