# Morena Rides V5

A low-data, mobile-first local e-hailing PWA for Morena Mall / Mmabatho.

## V5
- Real Supabase authentication (email/password)
- Rider / driver role profiles
- Shared rides database
- Realtime ride updates across phones
- Driver online/offline state synced to backend
- Driver GPS updates on demand
- Rider booking with map pin and distance/fare calculation
- Cash / EFT
- Rider ride lifecycle: requested → accepted → arrived → in progress → completed
- Admin live activity dashboard
- Local demo fallback when Supabase is not configured

## Connect the real backend
1. Create a Supabase project.
2. In Supabase SQL Editor, run `schema.sql`.
3. In Supabase Authentication, enable Email provider.
4. Copy the project URL and anon/publishable key into `config.js`.
5. Host the folder on HTTPS (required for browser GPS on most devices).
6. Open the site on two phones and create separate accounts: one rider and one driver.

Never put a Supabase service-role key in browser code.

## Important before public launch
The included RLS policies are deliberately development-friendly so the first live test is easy. Before accepting real customers or payments, restrict ride/profile visibility and role changes with production RLS and server-side/admin functions.

Connected project: https://aajlpzhgxxkrftcghkpb.supabase.co
Run schema.sql in the Supabase SQL Editor before testing live rides.
