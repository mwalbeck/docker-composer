def main(ctx):
    return [
        lint(),
        test("2_php8.1", "2-php8.1"),
        test("2_php8.2", "2-php8.2"),
        test("2_php8.3", "2-php8.3"),
        test("2_php8.4", "2-php8.4"),
        release("2_php8.1", "2-php8.1", app_env = "php8.1"),
        release("2_php8.2", "2-php8.2", app_env = "php8.2"),
        release("2_php8.3", "2-php8.3", app_env = "php8.3"),
        release("2_php8.4", "2-php8.4", app_env = "php8.4", custom_tags = "latest"),
    ]

def lint():
    return {
        "kind": "pipeline",
        "type": "docker",
        "name": "lint",
        "steps": [
            {
                "name": "Lint Dockerfiles",
                "image": "hadolint/hadolint:latest-debian",
                "pull": "if-not-exists",
                "commands": [
                    "hadolint --version",
                    "hadolint */Dockerfile",
                ],
            },
        ],
        "trigger": {
            "event": [
                "pull_request",
                "push",
            ],
            "ref": {
                "exclude": [
                    "refs/heads/renovate/*",
                ],
            },
        },
    }

def test(name, composer_variant, dockerfile = "Dockerfile"):
    return {
        "kind": "pipeline",
        "type": "docker",
        "name": "test_%s" % name,
        "steps": [
            {
                "name": "build test",
                "image": "plugins/docker",
                "pull": "if-not-exists",
                "settings": {
                    "dockerfile": "%s/%s" % (composer_variant, dockerfile),
                    "username": {
                        "from_secret": "dockerhub_username",
                    },
                    "password": {
                        "from_secret": "dockerhub_password_ro",
                    },
                    "dry_run": "true",
                    "repo": "mwalbeck/composer",
                },
            },
        ],
        "trigger": {
            "event": [
                "pull_request",
            ],
        },
        "depends_on": [
            "lint",
        ],
    }

def release(name, composer_variant, dockerfile = "Dockerfile", app_env = "", custom_tags = ""):
    return {
        "kind": "pipeline",
        "type": "docker",
        "name": "release_%s" % name,
        "steps": [
            {
                "name": "determine tags",
                "image": "mwalbeck/determine-docker-tags",
                "pull": "if-not-exists",
                "environment": {
                    "VERSION_TYPE": "docker_env",
                    "APP_NAME": "COMPOSER",
                    "DOCKERFILE_PATH": "%s/%s" % (composer_variant, dockerfile),
                    "APP_ENV": app_env,
                    "CUSTOM_TAGS": custom_tags,
                },
            },
            {
                "name": "build and publish",
                "image": "plugins/docker",
                "pull": "if-not-exists",
                "settings": {
                    "dockerfile": "%s/%s" % (composer_variant, dockerfile),
                    "username": {
                        "from_secret": "dockerhub_username",
                    },
                    "password": {
                        "from_secret": "dockerhub_password",
                    },
                    "repo": "mwalbeck/composer",
                },
            },
        ],
        "trigger": {
            "branch": [
                "master",
            ],
            "event": [
                "push",
            ],
        },
        "depends_on": [
            "lint",
        ],
    }
