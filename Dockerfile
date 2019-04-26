FROM maven

RUN apt update && apt install -y patch rake

# Set user and email for patches
ARG GIT_EMAIL="user@example.com"
ARG GIT_USER="user"
RUN git config --global user.email "$GIT_EMAIL" && git config --global user.name "$GIT_NAME"

WORKDIR /tmp/SportBukkit

# Copy the repo so we can build it
COPY . .

# Build and Clean
RUN rake \
  && mkdir /minecraft \
  && mv build/CraftBukkit/target/sportbukkit*.jar /minecraft/sportbukkit.jar \
  && rm -Rf /tmp \
  && rm -Rf /root/.m2/repository

WORKDIR /minecraft

EXPOSE 25565

CMD ["java", "-Xmx1G", "-jar", "sportbukkit.jar"]
