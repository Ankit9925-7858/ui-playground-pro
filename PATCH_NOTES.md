# Final routing and cloud project fix

This build fixes the reported issue where the browser could show:

`localhost:5173/http://localhost:5173/#editor`

The cause was route state being written as a complete URL/hash instead of a canonical route. Navigation is now centralized and only writes:

- `#home`
- `#login`
- `#signup`
- `#dashboard`
- `#editor/<project-id>`

Opening a project now includes its UUID. Refreshing the editor keeps the project ID in the URL and reloads the same Supabase row. The app also repairs malformed URLs created by older builds.

Cloud reads, updates and deletes are additionally scoped to the authenticated user's ID.
