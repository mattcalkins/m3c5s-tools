# Instructions

Create build, test, and run scripts similar to the ones in this repository.

# Binaries

## npx m3c5s-build2

To use this binary:

- Have a Dockerfile that builds a default image.

- Set the following properties in your `package.json`

    ```json
    {
        "m3c5s-tools": {
            "docker-image-name": "my-app"
        },
        "version": "1.0.0-alpha.1"
    }
    ```


## npx m3c5s-push2

This currently only works with AWS ECR registries.

- Have a Dockerfile that builds a default image.

- Set the following properties in your `package.json`

    ```json
    {
        "m3c5s-tools": {
            "docker-image-name": "my-app",
            "docker-image-registry-url": "<account>>.dkr.ecr.us-east-1.amazonaws.com/<name>"
        },
        "version": "1.0.0-alpha.1"
    }
    ```


## npx m3c5s-generate-timestamp-tag

This will return a timestamp in the following fomat. This format only contains characters that can be used as a Docker or Git tag.

```
2025-02-15--18-13-31-561--m0800
```
