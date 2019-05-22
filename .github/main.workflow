workflow "Deploy kamoulox" {
  on = "push"
  resolves = ["Push to Hub"]
}

action "Build kamoulox" {
  uses = "actions/docker/cli@76ff57a"
  args = "build -t jeanlaurent/kamoulox ."
}

action "Login to Docker Registry" {
  uses = "actions/docker/login@76ff57a"
  needs = ["Build kamoulox"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Push to Hub" {
  uses = "actions/docker/cli@76ff57a"
  needs = ["Login to Docker Registry"]
  args = "push jeanlaurent/kamoulox"
}
