FROM golang:1.13.8 as builder

WORKDIR /go/src/github.com/scaleway/scaleway-cloud-controller-manager

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY cmd/ cmd/
COPY scaleway/ scaleway/

ARG TAG
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -a -ldflags "-extldflags '-static' -X scaleway.version=${TAG}" -o scaleway-cloud-controller-manager ./cmd/scaleway-cloud-controller-manager

FROM scratch
WORKDIR /
COPY --from=builder /go/src/github.com/scaleway/scaleway-cloud-controller-manager/scaleway-cloud-controller-manager .
ENTRYPOINT ["/scaleway-cloud-controller-manager"]
