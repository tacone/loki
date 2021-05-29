export function allowCors(req, res, next) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "*");
  res.setHeader("Access-Control-Max-Age", 86400);

  if (req.method === "OPTIONS") {
    res.writeHead(200);
    res.end();
    return;
  }
  next && next();
}
