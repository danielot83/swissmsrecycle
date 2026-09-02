// Supabase Edge Function: delete-account
//
// This is the only safe way to let someone delete their own login
// (email + password) — it needs the service role key, which must
// NEVER be put in the website's own code (anyone could read it and
// delete any account). Here it lives only on Supabase's server,
// as a secret this function reads at runtime.
//
// What it does:
// 1. Checks the request really comes from a logged-in user (using
//    their own access token).
// 2. Deletes that user's listings and profile row.
// 3. Deletes their actual login (auth.users row) using the service
//    role key — this is the part a browser could never safely do.

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

Deno.serve(async (req) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors })

  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), { status: 401, headers: cors })
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const anonKey = Deno.env.get('SUPABASE_ANON_KEY')!
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

    // Confirm who's calling, using their own token (not the service key).
    const callerClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    })
    const { data: { user }, error: userErr } = await callerClient.auth.getUser()
    if (userErr || !user) {
      return new Response(JSON.stringify({ error: 'Not authenticated' }), { status: 401, headers: cors })
    }

    // Only from here on do we touch the service-role client.
    const adminClient = createClient(supabaseUrl, serviceRoleKey)

    await adminClient.from('listings').delete().eq('user_id', user.id)
    await adminClient.from('profiles').delete().eq('id', user.id)

    const { error: deleteErr } = await adminClient.auth.admin.deleteUser(user.id)
    if (deleteErr) {
      return new Response(JSON.stringify({ error: deleteErr.message }), { status: 500, headers: cors })
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { ...cors, 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), { status: 500, headers: cors })
  }
})
