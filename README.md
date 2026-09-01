# SwissMS Recycle

A shared board for the Swiss mass spectrometry community: labs and
platforms can offer spare consumables/equipment for free, or ask if
someone nearby has what they need.

Plain HTML/CSS/JS + [Supabase](https://supabase.com) (auth, database,
storage, realtime). No build step, no framework.

## Files

- `index.html` — public landing page
- `login.html` — sign up / log in / forgot password
- `reset-password.html` — set a new password after clicking the email link
- `app.html` — the board itself: browse with filters, or post something
- `style.css` — shared styles
- `supabase-client.js` — Supabase connection config
- `schema.sql` — database tables, storage bucket, and security policies
- `logo-brand.png`, `favicon.png`, `person-tof.png` — image assets

## 1. Supabase setup

1. Go to your Supabase project → **SQL Editor → New query**, paste the
   contents of `schema.sql`, and run it. This creates:
   - `profiles` (name, organization, email — shown on each listing)
   - `listings` (now with category, condition, location, contact email,
     year built, and a photo)
   - a `listing-photos` storage bucket for the photos people upload
   - all the Row Level Security policies and realtime setup

   If you already ran the old `schema.sql` before, it's safe to run this
   one again — it only adds what's missing.

2. **Settings → API**: copy the Project URL and Publishable (anon) key
   into `supabase-client.js` if you haven't already.

3. **Authentication → URL Configuration**: add your site's URL (e.g.
   `https://swissmsrecycle.app`) to the allowed redirect URLs — this is
   needed for the "forgot password" email link to bring people back to
   `reset-password.html` correctly.

## 2. What's new in this version

- **Sign up** now asks for full name and company/university, shown on
  the board next to each listing.
- **Password requirements** are shown live while creating an account
  (8+ characters, a letter, a number).
- **Forgot password** sends a reset email; `reset-password.html` is
  where people land to set a new one.
- **Browsing** is now its own view: a filterable grid (type, category,
  condition, university) with a click-through detail card showing the
  photo, description, contact email, year built, condition, etc., plus
  "Send email" and "Copy email" buttons.
- **Posting** is a fuller form: category, condition, location, year
  built, lab/university, contact email, and an optional photo (stored
  in Supabase Storage).

## Notes / honest limitations

- There's no automatic "email everyone when a request goes up" — a
  static site can't safely send bulk emails without a backend (and a
  service like that needs real credentials, which don't belong in a
  public repo). Right now, anyone can open a request and email the
  poster directly. If you want automatic notifications later, the
  clean way to add it is a Supabase Edge Function triggered on new
  rows, paired with a transactional email service (e.g. Resend) — that's
  a follow-up project, not something to bolt onto a static frontend.
- Anyone logged in can read every profile's name/organization/email —
  fine for a closed community board, but worth knowing.
- "Remove listing" only appears on your own posts — no moderator role yet.

