env "local" {
  url = "postgres://admin:password@localhost:5433/sourdough_db"
  dev = "docker://postgres/17/dev?search_path=public"

  schema {
    src = "file://schema.sql"
    repo {
      name = "sourdough"
    }
  }
}
