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
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY hlstats-cron /etc/cron.d/hlstats
RUN mkdir /logs && \
	echo "$(awk '!x{x=sub("^LOGDIR=.+","LOGDIR=/logs");};1;' /scripts/run_hlstats)" > /scripts/run_hlstats && \
	chmod +x /scripts/run_* /scripts/hlstats-*.pl /scripts/hlstats.pl && \
	chmod +x /docker-entrypoint.sh

WORKDIR /scripts

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "run" ]

HEALTHCHECK CMD /scripts/run_hlstats status || exit 1
