
FILE=_version # Reference to file that maintains the version within our codebase
CODE_VERSION=$(shell cat ${FILE} | tr -d '[:blank:]') # Get version that's set in our codebase
NEW_VERSION=$(CODE_VERSION)
DATE=$(shell date "+%Y-%m-%dT%H:%M:%SZ%z")
GIT_TAG=$(shell git describe --tags --abbrev=0 --exclude '*-dev' --exclude '*-qa' 2>/dev/null \
&& : || git rev-list --max-parents=0 --abbrev-commit HEAD) # Get the Git Tag, which represents the version set in Git
TOKEN=
CREATE_RELEASE=$(shell curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $(TOKEN)" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/kdmiltner/test/releases -d '{"tag_name":"$(strip $(NEW_VERSION))","target_commitish":"main","name":"$(strip $(NEW_VERSION))","body":"Deployed on $(DATE)","draft":false,"prerelease":false,"generate_release_notes":true}')
SHOW_TAGS=$(shell git log --oneline --decorate=short)



date:
	date "+%Y-%m-%dT%H:%M:%SZ%z"

git_version:
	echo $(GIT_TAG)

code_version:
	echo $(CODE_VERSION)

compare_versions:
	@if [ $(GIT_TAG) = $(CODE_VERSION) ]; then\
		echo FAIL.\
		$(CODE_VERSION) is not greater than $(GIT_TAG).\
		Please update the $(FILE) file.;\
	else\
		echo PASS;\
	fi

create_release:
	@git tag $(CODE_VERSION) 
	echo $(CREATE_RELEASE)
