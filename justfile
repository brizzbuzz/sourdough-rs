default:
    @just --list

# Run the server
server:
    @cargo run --bin server

# Run the server and worker in development mode
dev:
    @cargo watch -x run --bin server

hakari:
    @cargo hakari generate
    @cargo hakari manage-deps