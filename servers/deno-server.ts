import { serve } from "https://deno.land/std@0.205.0/http/server.ts";

const PORT = 3000;

serve((req) => {
  const url = new URL(req.url);

  if (url.pathname === "/ping") {
    return new Response(JSON.stringify({ message: "pong" }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  if (url.pathname === "/compute") {
    let total = 0;
    for (let i = 0; i < 1e7; i++) {
      total += i;
    }
    return new Response(JSON.stringify({ result: total }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  if (url.pathname === "/memory") {
    const largeArray = new Array(1e6).fill("x");
    return new Response(JSON.stringify({ message: "memory allocated", size: largeArray.length }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  if (url.pathname === "/bulk") {
    return new Response(JSON.stringify({ message: "bulk request test" }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response("Not Found", { status: 404 });
}, { port: PORT });

console.log(`Deno server listening on port ${PORT}`); 