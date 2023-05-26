FILE=_version # Reference to file that maintains the version within our codebase
CODE_VERSION=$(shell cat ${FILE}) # Get version that's set in our codebase
NEW_VERSION=$(CODE_VERSION)
GIT_TAG=$(shell git describe --tags --abbrev=0 --exclude '*-dev' --exclude '*-qa' 2>/dev/null \
&& : || git rev-list --max-parents=0 --abbrev-commit HEAD) # Get the Git Tag, which represents the version set in Git
GITHUB_TOKEN=
CREATE_PRERELEASE=$(shell curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $(GITHUB_TOKEN)" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/kdmiltner/test/releases -d '{"tag_name":"$(strip $(NEW_VERSION))","target_commitish":"main","name":"$(strip $(NEW_VERSION))","body":"$(DESCRIPTION)","draft":false,"prerelease":true,"generate_release_notes":true}')


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
		echo PASS\
		echo $(NEW_VERSION);\
	fi

create_release:
	@git tag $(CODE_VERSION) 
	echo $(CREATE_PRERELEASE)
