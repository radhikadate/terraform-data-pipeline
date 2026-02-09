CREATE OR REPLACE VIEW public.v_order_manifest_summary AS
SELECT 
    o.order_id,
    o.status AS order_status,
    o.type AS order_type,
    m.manifest_status AS manifest_status,
    CASE 
        WHEN m.order_id IS NULL THEN 'PENDING_MANIFEST' 
        ELSE 'SYNCED' 
    END AS manifest_sync_status
FROM 
    public.orders o
LEFT JOIN 
    public.manifest m ON o.order_id = m.order_id;
