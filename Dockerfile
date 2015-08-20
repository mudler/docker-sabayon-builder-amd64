FROM sabayon/spinbase-amd64-squashed

MAINTAINER mudler <mudler@sabayonlinux.org>

# Perform post-upgrade tasks (mirror sorting, updating repository db)
ADD ./script/post-upgrade.sh /post-upgrade.sh
RUN /bin/bash /post-upgrade.sh  && rm -rf /post-upgrade.sh

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["emerge"]


