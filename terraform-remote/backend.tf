terraform {
  backend "remote" {
    organization = "whiterabbit"
    
    workspaces {
      name = "python-concurrency-experiment"
    }
  }
}
