#!/bin/bash
set -x
docker compose run --rm jenkins_agent_gradle sh -c "cd workspace; ./test.sh"