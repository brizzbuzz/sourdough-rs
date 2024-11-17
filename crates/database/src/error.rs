use thiserror::Error;

#[derive(Error, Debug)]
pub enum DatabaseError {
    #[error("Database error: {0}")]
    Sqlx(#[from] sqlx::Error),

    #[error("Record not found")]
    NotFound,

    #[error("Validation error: {0}")]
    Validation(String),

    #[error("Connection error: {0}")]
    Connection(String),
}

pub type Result<T> = std::result::Result<T, DatabaseError>;