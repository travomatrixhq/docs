export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname;

    /**
     * CONFIGURATION: Update this to your actual Mintlify project URL
     * This is the hidden URL that Cloudflare will fetch from.
     */
    const MINTLIFY_ORIGIN = "https://travomatrix.mintlify.app"; 

    // 1. Define Public "Teaser" Routes
    // These paths (and their sub-paths like assets) are always accessible without authentication.
    const publicPaths = [
      '/',                      // Root redirect
      '/guides/introduction',    // Landing page
      '/guides/quickstart',     // How to sign up
      '/logo-light.svg',        // Brand assets
      '/logo-dark.svg',
      '/favicon.png',
      '/_next',                 // Mintlify framework assets required to render the public pages
      '/api/public'             // Any explicitly public API endpoints
    ];

    // Helper function to check if the current request is for a public path
    const isPublicPath = publicPaths.some(p => path === p || path.startsWith(p + '/'));

    // 2. Check for Authentication
    // We check for a session cookie from app.travomatrix.com.
    const cookieString = request.headers.get('Cookie') || '';
    const isAuthenticated = cookieString.includes('travomatrix_session=');

    // 3. Routing Logic
    if (isPublicPath || isAuthenticated) {
      // Access Granted: Proxy to Mintlify
      
      // We must rewrite the URL to point to the Mintlify origin
      const originUrl = new URL(path + url.search, MINTLIFY_ORIGIN);
      
      const originRequest = new Request(originUrl, {
        method: request.method,
        headers: new Headers(request.headers),
        body: request.body,
        redirect: 'manual'
      });

      // Crucial: Set the Host header so Mintlify knows which project to serve
      originRequest.headers.set('Host', new URL(MINTLIFY_ORIGIN).hostname);
      
      // Optionally strip sensitive cookies before sending to Mintlify
      originRequest.headers.delete('Cookie');
      
      return fetch(originRequest);
      
    } else {
      // 4. Unauthorized Access Blocked: Redirect to Login
      const loginUrl = new URL('https://app.travomatrix.com/login');
      
      // Pass the current path so the app can redirect the user back after login
      loginUrl.searchParams.set('next', url.toString());
      
      return Response.redirect(loginUrl.toString(), 302);
    }
  },
};