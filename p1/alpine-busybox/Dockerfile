FROM alpine:3.14

RUN apk update && apk add busybox

ENV HOSTNAME=alpine-host

CMD ["sh", "-c", "while true; do sleep 1000; done"]