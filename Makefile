RELEASE_OPENPGP_FINGERPRINT ?= C505B5C93B0DB3D338A1B6005FE92C12EE88E1F0

## release {{{

.PHONY: release-versionbump
release-versionbump: haxelib.json
	editor $?
	sh -c 'git commit --all --message "Release version $$(jq --raw-output '.version' '$<')"'

.PHONY: release-local
release-local: haxelib.json
	git tag --sign --local-user "$(RELEASE_OPENPGP_FINGERPRINT)" --message "Released version $(shell jq --raw-output '.version' $<)" "v$(shell jq --raw-output '.version' $<)"

.PHONY: release-publish
release-publish:
	git push --follow-tags
	haxelib submit .

.PHONY: release
release: release-versionbump release-local release-publish
## }}}
