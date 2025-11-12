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
ARG UID=1000
ARG GID=1000
ARG USER=electrs
ARG GROUP=electrs

# Create group and user
RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GID} -m -s /bin/bash ${USER} && \
    mkdir -p /home/${USER}/electrs/bin /home/${USER}/electrs/db /home/${USER}/electrs/bitcoin && \
    chown -R ${USER}:${GROUP} /home/${USER}

# Copy the built binary
COPY --from=build /electrs/target/release/electrs /home/${USER}/electrs/bin/

# Switch to non-root user
USER ${USER}
WORKDIR /home/${USER}/electrs

# Expose port 50001
EXPOSE 50001

# Run the binary
CMD ["./bin/electrs"]
