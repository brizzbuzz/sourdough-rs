use sqlx::postgres::{PgPool, PgPoolOptions};
use tracing::info;

use crate::error::{DatabaseError, Result};

pub async fn create_pool(database_url: &str) -> Result<PgPool> {
    info!("Creating database connection pool...");

    PgPoolOptions::new()
        .max_connections(5)
        .acquire_timeout(std::time::Duration::from_secs(3))
        .connect(database_url)
        .await
        .map_err(|e| DatabaseError::Connection(e.to_string()))
}

#[cfg(test)]
pub mod test_helpers {
    use super::*;
    use dotenv::dotenv;

    pub async fn create_test_pool() -> PgPool {
        dotenv().ok();
        let database_url = std::env::var("DATABASE_URL")
            .expect("DATABASE_URL must be set for tests");

        create_pool(&database_url)
            .await
            .expect("Failed to create test pool")
    }
}