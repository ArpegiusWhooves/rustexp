FROM grspirit/cargo-web as builder

WORKDIR /build

COPY *.toml /build/

RUN mkdir src && echo 'fn main() {}' >> src/main.rs
RUN cargo web build --release
RUN rm -r src

COPY ./src /build/src
COPY ./static /build/static

ENV RUST_BACKTRACE=full
RUN cargo web build --release

FROM joseluisq/static-web-server

COPY --from=builder /build/target/wasm32-unknown-unknown/release/rustexp.js ./public/
COPY --from=builder /build/target/wasm32-unknown-unknown/release/rustexp.wasm ./public/
COPY static/* ./public/