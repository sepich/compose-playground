
# All of these examples do not work with the same problem

# https://git-scm.com/docs/http-protocol#_smart_service_git_upload_pack
#while curl -s -X POST -H "Content-Type: application/x-git-upload-pack-request" -d @10M http://localhost:8080/upload > /dev/null

# https://distribution.github.io/distribution/spec/api/#stream-upload
#while curl -s -X PATCH -H "Content-Type: application/octet-stream" -d @10M http://localhost:8080/upload > /dev/null

# https://datatracker.ietf.org/doc/html/rfc1867.html
while curl -s -d @10M "http://localhost:8080/upload" > /dev/null
do
	printf "."
done
printf "f\n"
