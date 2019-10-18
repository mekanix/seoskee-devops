REGGAE_PATH = /usr/local/share/reggae
SERVICES = backend https://github.com/seoskee/backend \
	   frontend https://github.com/seoskee/frontend

collect: up
	@bin/collect.sh

shell:
	@make -C services/backend shell

.include <${REGGAE_PATH}/mk/project.mk>
