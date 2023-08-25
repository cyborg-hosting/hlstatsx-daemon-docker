# syntax=docker/dockerfile:1
FROM debian:bullseye-slim AS base
RUN apt-get update && \
	apt-get -y install unzip
ADD https://github.com/A1mDev/hlstatsx-community-edition/archive/master.zip .
RUN unzip master.zip && \
	mv hlstatsx-community-edition-master/scripts /

FROM debian:bullseye-slim
RUN apt-get update && \
	apt-get -y install build-essential \
					   libssl-dev \
					   zlib1g-dev \
					   libdbd-mysql-perl \
					   openssl \
					   cpanminus \
					   cron && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
RUN	cpanm MaxMind::DB::Reader && \
	cpanm GeoIP2::Database::Reader && \
	cpanm Syntax::Keyword::Try
COPY --from=base /scripts /scripts
COPY docker-entrypoint.sh /
COPY hlstats-cron /etc/cron.d/hlstats
RUN cd /scripts && \
	chmod +x run_* hlstats-*.pl && \
	chmod u+x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "cron" ]

HEALTHCHECK CMD /scripts/run_hlstats status || exit 1
