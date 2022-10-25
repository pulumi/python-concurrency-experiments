terraform {
  cloud {
    organization = "whiterabbit"

    workspaces {
      name = "python-concurrency-experiment-cloud"
    }
  }
}
