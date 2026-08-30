// ============================================================
// SwissMS Recycle — Supabase client
// Fill in your project's URL and anon (public) key below.
// Both are found in Supabase: Settings → API.
// The anon key is safe to expose in frontend code — access is
// controlled by the Row Level Security policies on the tables.
// ============================================================
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = 'https://xdjlrgatomdhqkykmwxr.supabase.co'
const SUPABASE_ANON_KEY = 'sb_publishable_0v4091fUsvfO2sc_8twCCg_ERwE9j2a'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
