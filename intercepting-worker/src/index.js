/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */


export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    // Only intercept requests to the root path
    if (url.pathname === "/") {
      const userAgent = request.headers.get('User-Agent') || '';
      
      // Check if the request is from curl
      if (userAgent.includes('curl')) {
        // Serve content from index.txt for curl requests
        // Assuming index.txt is a static asset on your Cloudflare Pages or elsewhere
        const textResponse = await fetch("https://superuser.run/index.txt"); // Adjust URL as necessary
        return new Response(await textResponse.text(), {
          headers: { 'Content-Type': 'text/plain' }
        });
      }
    }
  
    // Fetch and return the original response for all other cases
    return fetch(request);
  },
};