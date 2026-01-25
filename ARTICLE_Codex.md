# Vibecoding an IRIS BI API + UI with Codex

I wanted a small but realistic IRIS project that includes both a REST API and a frontend. The **samples BI demo** was perfect: it ships with persistent classes and meaningful data, so I could build a UI on top.

I installed the demo with:

```
zpm "install samples-bi-demo"
```

My setup is VS Code with ObjectScript tooling and the Codex CLI plugin. I started from a basic ObjectScript template repo from Open Exchange.

## Step 1: Define the REST API (Swagger 2.0)

IRIS 2025.3 supports Swagger 2.0, so I asked Codex to generate a spec for CRUD operations on `HoleFoods.Product`, and to derive `Product` from `%JSON.Adaptor` for clean JSON serialization. I also asked it to follow the local `AGENTS.md` instructions.

This produced:
- `HoleFoods.api.spec` (Swagger spec)
- `HoleFoods.api.disp` (generated dispatch)
- `HoleFoods.api.impl` (implementation)

I set the web app base to `/holefoods/api` and added the CSP application entry to `module.xml` so it is created on install. I also asked for a helper security class, `HoleFoods.api.security`, to configure roles and CORS for a secure but usable API.

## Step 2: Implement the endpoints

Codex filled in the implementation for the spec endpoints, and I added extra capabilities:

- `/products` CRUD
- `/outlets` list
- `/transactions` list with filters (date range, outlet, SKU)
- `_spec` endpoint for Swagger UI

The IRIS-side API is ready to test through Swagger UI:

```
zpm "install swagger-ui"
```

## Step 3: Build the frontend (Vite + React + TS)

I asked Codex to build a Vite + React + TS UI in `frontend/`, wired to `/holefoods/api`.

Highlights:
- Product CRUD UI
- Transactions browser with filters
- A sales-by-year dashboard (SKU + outlet + year filters)
- Monthly sales chart

The UI runs locally at:

```
http://localhost:5174/
```

## Step 4: Add unit tests

To keep the API stable, I asked Codex to generate unit tests for the endpoints. Tests live in:

```
tests/HoleFoods/api/tests/UnitTests.cls
```

Running tests:

```
zpm "test esh-vibe-back-demo"
```

## Result

With the API, UI, and tests in place, I now have a complete demo: CRUD for products, filtered transaction views, sales dashboards, and Swagger-based documentation. Codex handled most of the heavy lifting; I focused on constraints and validation.

## Conclusion

This was a great example of “vibecoding” a full stack IRIS app: persistent classes, REST API, UI, and tests. The workflow is fast, repeatable, and easy to extend for new features.
