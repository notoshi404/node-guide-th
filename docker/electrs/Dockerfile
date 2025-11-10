FROM rust:slim-bookworm AS build

# Declare build args
ARG VERSION=master

# Install build dependencies
RUN apt-get update && apt-get install -qqy \
    clang cmake build-essential git pkg-config libssl-dev \
    librocksdb-dev

# Clone and build electrs
RUN git clone https://github.com/romanz/electrs.git /electrs && \
    cd /electrs && \
    git checkout ${VERSION} && \
    cargo build --locked --release


FROM debian:bookworm-slim AS runtime

# Declare runtime args
ARG GID=1000
ARG UID=1000
ARG USERNAME=electrs
ARG GROUPNAME=electrs

# Create group and user
RUN groupadd -g ${GID} ${GROUPNAME} && \
    useradd -u ${UID} -g ${GID} -m -s /bin/bash ${USERNAME} && \
    mkdir -p /home/${USERNAME}/electrs/bin /home/${USERNAME}/electrs/db /home/${USERNAME}/electrs/bitcoin && \
    chown -R ${USERNAME}:${GROUPNAME} /home/${USERNAME}

# Copy the built binary
COPY --from=build /electrs/target/release/electrs /home/${USERNAME}/electrs/bin/

# Switch to non-root user
USER ${USERNAME}
WORKDIR /home/${USERNAME}/electrs

# Expose port 50001
EXPOSE 50001

# Run the binary
CMD ["./bin/electrs"]
