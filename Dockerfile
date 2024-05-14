FROM nvcr.io/nvidia/pytorch:23.06-py3

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    aria2 \
    bash-completion \
    ca-certificates \
    curl \
    git \
    git-lfs \
    htop \
    less \
    libpython3.10-dev \
    openjdk-17-jdk \
    python3-pip \
    python3.10 \
    python3.10-venv \
    software-properties-common \
    ssh \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    zip \
    zstd

RUN apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Make bash history persistent
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory \
    && echo "$SNIPPET" >> "/home/$USERNAME/.bashrc"

RUN adduser user dialout
USER $USERNAME