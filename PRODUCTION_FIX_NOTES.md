# Production cleanup applied

- Removed `https://cdn.tailwindcss.com` from the main application document.
- Added standard Tailwind CSS + PostCSS build configuration.
- Added a local SVG favicon to remove the missing `/favicon.ico` request.
- Preserved the existing editor, Supabase auth, project dashboard, autosave, component library, export/import, and preview behavior.

## Run

```bash
npm install
npm run build
npm run preview
```

## Important preview note
The live editor preview currently uses Tailwind's browser CDN because the user can type arbitrary Tailwind utility classes at runtime. Removing that runtime compiler completely would stop newly typed arbitrary Tailwind classes from appearing in the preview. The production warning from the main application shell is fixed by the PostCSS setup; the preview compiler can be migrated to a self-hosted runtime compiler in a later dedicated change if required.
