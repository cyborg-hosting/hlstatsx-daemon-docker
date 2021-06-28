# syntax=docker/dockerfile:1
FROM debian:buster-slim

RUN apt-get update && \
	apt-get -y install build-essential \
	libssl-dev zlib1g-dev libdbd-mysql-perl \
	libsyntax-keyword-try-perl openssl unzip cron

RUN	cpan CPAN && \
	cpan MaxMind::DB::Reader && \
	cpan GeoIP2::Database::Reader

WORKDIR /app/

ADD https://github.com/NomisCZ/hlstatsx-community-edition/archive/master.zip ./
RUN unzip master.zip && \
	mv hlstatsx-community-edition-master/scripts ./ && \
	rm -R hlstatsx-community-edition-master master.zip && \
	cd scripts && \
	chmod +x hlstats-awards.pl hlstats.pl hlstats-resolve.pl run_hlstats

WORKDIR /app/scripts/

CMD [ "perl", "hlstats.pl" ]
