# SwissMS Recycle

A shared board for the Swiss mass spectrometry community: labs and
platforms can offer spare consumables/equipment for free, or ask if
someone nearby has what they need.

Plain HTML/CSS/JS + [Supabase](https://supabase.com) (auth, database,
realtime). No build step, no framework.

## Files

- `index.html` — public landing page
- `login.html` — email + password log in / sign up
- `app.html` — protected board (requires login)
- `style.css` — shared styles
- `supabase-client.js` — Supabase connection config (fill in your keys)
- `schema.sql` — database table + security policies

## 1. Create the Supabase project

1. Go to [supabase.com](https://supabase.com) → **New project**. Name it
   e.g. `swissmsrecycle`.
2. Once it's ready, open **SQL Editor → New query**, paste the contents
   of `schema.sql`, and run it. This creates the `listings` table, the
   security rules, and turns on realtime updates.
3. Go to **Settings → API** and copy:
   - **Project URL**
   - **anon public** key
4. Paste both into `supabase-client.js`, replacing the placeholders.

## 2. Email confirmation (optional, recommended for a closed community)

By default Supabase requires people to click a confirmation link
before their account works. Since this is meant for a known community:

- **Settings → Authentication → Sign In / Providers → Email** →
  turn **off** "Confirm email" if you want people to be logged in
  immediately after creating an account.
- Leave it **on** if you'd rather verify people own the email address
  first (safer if the signup page is public).

## 3. Try it locally

Any static file server works, for example:

```bash
npx serve .
```

Open the printed local address, sign up with an email + password,
and you should land on the board.

## 4. Put it on GitHub

```bash
git init
git add .
git commit -m "SwissMS Recycle: landing, login, board"
git branch -M main
git remote add origin https://github.com/<your-user>/swissmsrecycle.git
git push -u origin main
```

## 5. Publish with GitHub Pages

1. In the repo: **Settings → Pages → Source → Deploy from a branch**,
   branch `main`, folder `/ (root)`. Save.
2. GitHub gives you a URL like `https://<your-user>.github.io/swissmsrecycle/`.
   Confirm the site works there first.

## 6. Point swissmsrecycle.app at it

1. In the repo root, create a file named `CNAME` containing exactly:
   ```
   swissmsrecycle.app
   ```
2. At your domain's DNS provider, add:
   - An **A** record for the root domain pointing to GitHub Pages' IPs:
     `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
   - (Optional) a **CNAME** record for `www` pointing to
     `<your-user>.github.io`
3. Back in **Settings → Pages → Custom domain**, enter
   `swissmsrecycle.app` and wait for GitHub to issue the certificate,
   then turn on **Enforce HTTPS**.

## Notes / possible next steps

- Right now anyone who creates an account can read and post — there's
  no admin approval step. If you want to restrict signups to known
  institutional email domains, that's a small addition to the sign-up
  check.
- "Remove" only appears on your own listings; there's no separate
  admin/moderator role yet.
- The board currently only has Offer/Request — a category field
  (consumables / instrument parts / standards…) would be a natural
  next addition if the list grows.
