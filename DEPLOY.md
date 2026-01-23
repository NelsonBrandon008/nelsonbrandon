Deploying this Flask app to a stable public URL
===============================================

I'll outline two easy hosting options that will give you a persistent HTTPS URL: Render (recommended) and Heroku (alternative). Both require creating an account and connecting the repository (or pushing a branch). This repo is already ready for deployment; I added a `Procfile` and `gunicorn` to `requirements.txt` so most PaaS providers will use Gunicorn to run the app.

Quick checklist before deploying
- Ensure your repo is pushed to GitHub (or a Git provider supported by the host).
- Confirm `requirements.txt` includes `gunicorn` (done in this commit).
- Ensure there are no hard-coded debug settings. `web_app.py` runs with `debug=False`.

Option A — Render (recommended, free tier available)
1. Create a Render account at https://render.com and connect your GitHub account.
2. Create a new "Web Service" and pick this repository and the branch you want to deploy.
3. Use the following settings:
   - Environment: Python
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `gunicorn web_app:app --bind 0.0.0.0:$PORT`
4. Click Create — Render will build and give you a stable URL like `https://your-service.onrender.com`.

Render: CI / auto-deploy using GitHub Actions (one-click after setup)
---------------------------------------------------------------
If you want deploys to happen automatically on push to `main`, you can use the GitHub Actions workflow included in this repo (`.github/workflows/deploy_render.yml`). It triggers tests and then calls the Render API to create a deploy. To enable it you must:

1. Create the service on Render at least once via the Render dashboard (Render will provision a service id).
2. In your GitHub repository, add two repository secrets:
   - `RENDER_API_KEY` — a Render API key with `deploy`/`service` scope. Create it at https://dashboard.render.com/account/api-keys
   - `RENDER_SERVICE_ID` — the Render service id (visible on your service dashboard, or from the URL when viewing the service)

3. Push to `main`. The workflow will run, execute tests, and then POST to the Render API to trigger a deploy for the commit. You can monitor deploy progress on the Render dashboard.

Notes:
- The workflow will fail fast if the two secrets are not set. The `deploy` job depends on `test` so tests run first.
- If you prefer to let Render build directly from the repo (no API deploy), connect the repo in the Render UI; render will auto-deploy on push by default.


Option B — Heroku (easy, free tier retired but hobby plans exist)
1. Install the Heroku CLI and login (`heroku login`).
2. From the repo root, create an app: `heroku create your-app-name` (or let Heroku pick a name).
3. Push your code: `git push heroku main` (or the branch name).
4. Heroku will install dependencies from `requirements.txt` and use the `Procfile` to run the app using Gunicorn.
5. The app will be visible at `https://your-app-name.herokuapp.com` (or the custom domain you add).

Option C — Docker + any host that supports Docker (e.g., Fly.io, DigitalOcean Apps)
1. Add a Dockerfile (I can add one for you if you want).
2. Push the container to a registry and deploy to the provider.

Notes & follow-ups I can do for you
- Add a Dockerfile and small CI (GitHub Actions) to auto-deploy on push.
- Reserve a fixed subdomain on Render (or configure a custom domain).
- Help configure HTTPS and environment variables if/when needed.

If you want me to proceed with Render steps I can: (a) provide the exact UI clicks, (b) create a GitHub Actions workflow to auto-deploy, or (c) prepare a Dockerfile and `render.yaml` for a reproducible deploy. Which would you like? 
