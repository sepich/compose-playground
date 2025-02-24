build:
	docker build -t go-upload-server .
	kubectl delete --ignore-not-found=true -f app.yaml
	kubectl delete --ignore-not-found=true pod -l app=app
	kind load docker-image go-upload-server
	kubectl apply -f app.yaml
	kubectl wait --for=condition=ready pod -l app=app

setup: build
	dd if=/dev/urandom of=10M bs=1M count=1
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
	kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80

curl:
	curl -d @10M http://localhost:8080/upload > /dev/null
#curl -X POST -H "Content-Type: application/x-git-upload-pack-request" -d @10M http://localhost:8080/upload
#curl -X PATCH -H "Content-Type: application/octet-stream" -d @10M http://localhost:8080/upload

reproduce:
	./reproduce.sh
	kubectl -n ingress-nginx logs --tail=5 -l app.kubernetes.io/component=controller

# Check static nginx without lua
static:
	kubectl delete --ignore-not-found=true cm nginx
	sh -c ' \
		ip=`kubectl get svc app -o custom-columns=:.spec.clusterIP --no-headers`;\
		cat nginx.conf | sed "s/SVC_APP/$$ip/g" > /tmp/nginx.conf;\
		kubectl create configmap nginx --from-file=/tmp/nginx.conf;\
	'
	kubectl delete --ignore-not-found=true deploy nginx && kubectl apply -f nginx.yaml
	sleep 1 && kubectl wait --for=condition=ready pod -l app=nginx
	kubectl port-forward svc/nginx 8080

reproduce-static:
	./reproduce.sh
	kubectl logs --tail=5 -l app=nginx
