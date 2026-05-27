# Kamoulox — Architecture Overview

## Summary

Kamoulox is a minimal Go CLI tool that generates absurd French sentences in the style of the [Kamoulox](https://fr.wikipedia.org/wiki/Kamoulox) TV word game. It randomly pairs French verbs (e.g. "je mange", "je programme") with noun phrases (e.g. "un poulpe", "Donald Trump") to produce comical sentences like *"Je photocopie un seau et déneige un palmier."* The project is packaged as a multi-arch Docker image (`jeanlaurent/kamoulox`) built via GitHub Actions CI, producing a minimal `scratch`-based container that prints one random sentence per invocation.

## Architecture Diagram

```mermaid
graph TD
    subgraph "Source Code (Go)"
        MAIN["cmd/kamoulox/main.go<br/><i>CLI entry point</i>"]
        GEN["pkg/kamoulox/kamoulox.go<br/><i>Sentence generator</i>"]
        VERBS["pkg/kamoulox/verbs.go<br/><i>~78 French verb phrases</i>"]
        OBJECTS["pkg/kamoulox/objects.go<br/><i>~82 French noun phrases</i>"]
    end

    subgraph "Build & Distribution"
        DOCKERFILE["Dockerfile<br/><i>Multi-stage: golang:1.23-alpine → scratch</i>"]
        CI[".github/workflows/docker-image.yml<br/><i>GitHub Actions CI</i>"]
        DOCKERHUB["Docker Hub<br/><i>jeanlaurent/kamoulox</i>"]
    end

    subgraph "Runtime"
        USER["User"]
        DOCKER_RUN["docker run jeanlaurent/kamoulox"]
        OUTPUT["Stdout: random Kamoulox sentence"]
    end

    MAIN -->|"calls"| GEN
    GEN -->|"reads word lists"| VERBS
    GEN -->|"reads word lists"| OBJECTS
    VERBS -->|"random selection<br/>without repeats"| GEN
    OBJECTS -->|"random selection<br/>without repeats"| GEN

    MAIN --> DOCKERFILE
    GEN --> DOCKERFILE
    VERBS --> DOCKERFILE
    OBJECTS --> DOCKERFILE
    DOCKERFILE -->|"built by"| CI
    CI -->|"pushes image"| DOCKERHUB

    USER -->|"runs"| DOCKER_RUN
    DOCKERHUB -->|"pulls image"| DOCKER_RUN
    DOCKER_RUN -->|"executes binary"| MAIN
    MAIN -->|"prints"| OUTPUT
```

## Key Components

| Component | Description |
|---|---|
| **`main.go`** | CLI entry point — just calls the generator and prints |
| **`kamoulox.go`** | Core logic: picks 2–4 random verb+object pairs, capitalizes correctly, joins with commas + "et" |
| **`verbs.go`** | ~78 first-person French verb phrases ("je mange", "j'invoque"…) |
| **`objects.go`** | ~82 French noun phrases & celebrity names ("un poulpe", "Donald Trump"…) |
| **`Dockerfile`** | Multi-stage: compiles in `golang:1.23-alpine`, ships in `scratch` (~2 MB final image) |
| **GitHub Actions** | Builds multi-arch (`amd64` + `arm64`), pushes to Docker Hub with SBOM + provenance attestation |

The sentence generator ensures **no word repeats** within a single sentence.
