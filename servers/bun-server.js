const PORT = 3000;

Bun.serve({
  port: PORT,
  fetch(req) {
    const url = new URL(req.url);

    if (url.pathname === "/ping") {
      return Response.json({ message: "pong" });
    }

    if (url.pathname === "/compute") {
      let total = 0;
      for (let i = 0; i < 1e7; i++) {
        total += i;
      }
      return Response.json({ result: total });
    }

    if (url.pathname === "/memory") {
      const largeArray = new Array(1e6).fill("x");
      return Response.json({ message: "memory allocated", size: largeArray.length });
    }

    if (url.pathname === "/bulk") {
      return Response.json({ message: "bulk request test" });
    }

    return new Response("Not Found", { status: 404 });
  },
  
  development: {
    logLevel: "info"
  }
});

console.log(`Bun server listening on port ${PORT}`);