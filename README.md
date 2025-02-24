# https://github.com/kubernetes/ingress-nginx/issues/12875

```
$ make reproduce
./reproduce.sh
....f
kubectl -n ingress-nginx logs --tail=5 -l app.kubernetes.io/component=controller
2025/02/24 11:02:55 [warn] 14047#14047: *1795460 a client request body is buffered to a temporary file /tmp/nginx/client-body/0000006085, client: 127.0.0.1, server: _, request: "PATCH /upload HTTP/1.1", host: "localhost:8080"
127.0.0.1 - - [24/Feb/2025:11:02:55 +0000] "PATCH /upload HTTP/1.1" 401 3965 "-" "curl/8.7.1" 1036477 0.002 [default-app-8080] [] 10.244.0.28:8080 3959 0.000 401 2dc4fa4f0f2069d41bd345534f6feb74
2025/02/24 11:02:55 [warn] 14047#14047: *1795462 a client request body is buffered to a temporary file /tmp/nginx/client-body/0000006086, client: 127.0.0.1, server: _, request: "PATCH /upload HTTP/1.1", host: "localhost:8080"
2025/02/24 11:02:55 [crit] 14047#14047: *1795462 pread() "/tmp/nginx/client-body/0000006086" failed (9: Bad file descriptor) while sending request to upstream, client: 127.0.0.1, server: _, request: "PATCH /upload HTTP/1.1", upstream: "http://10.244.0.28:8080/upload", host: "localhost:8080"
127.0.0.1 - - [24/Feb/2025:11:02:55 +0000] "PATCH /upload HTTP/1.1" 401 3911 "-" "curl/8.7.1" 1036477 0.504 [default-app-8080] [] 10.244.0.28:8080 3909 0.000 502 8d4ae3aa7d4099a867ac9a9c58cba011
```

## Steps
- `make setup` (keep this tab)
- `make reproduce` (in second tab)

## Modify
- modify `main.go`
- `make build` (in second tab)
- `make reproduce` (in second tab)
