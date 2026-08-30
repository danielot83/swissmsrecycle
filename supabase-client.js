// ============================================================
// SwissMS Recycle — Supabase client
// Fill in your project's URL and anon (public) key below.
// Both are found in Supabase: Settings → API.
// The anon key is safe to expose in frontend code — access is
// controlled by the Row Level Security policies on the tables.
// ============================================================
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co'
const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
