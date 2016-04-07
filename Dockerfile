# Dockerfile to run REPET (single host)

FROM robsyme/docker-sge

MAINTAINER Rob Syme <robsyme@gmail.com>

# Change these to your GIRINST username and password
ENV GIRINST_USERNAME AzureDiamond
ENV GIRINST_PASSWORD hunter2

# Basic REPET requirements
RUN apt-get update && apt-get install -yqq mysql-client ncbi-blast+ python-mysqldb python-yaml

#ADD REPET
RUN wget https://urgi.versailles.inra.fr/download/repet/REPET_linux-x64-2.2.tar.gz \
&& tar --directory / -xvf /tmp/REPET_linux*.tar.gz \
&& rm REPET_linux*.tar.gz \
&& mv /REPET_linux* /REPET \
&& echo "REPET_PATH=/REPET" >> /etc/environment \
&& echo "export PATH=\$PATH:/REPET/bin" >> /etc/profile \
&& echo "export PYTHONPATH=/REPET" >> /etc/profile

# Optional Dependencies - general
RUN apt-get install -yqq tree genometools blast2 hmmer mcl 

# Optional Dependencies - recon
RUN mkdir -p /opt/recon \
&& cd /opt/recon \
&& wget http://www.repeatmasker.org/RECON-1.07.tar.gz \
&& tar -xvf RECON*.tar.gz \
&& rm RECON*.tar.gz \
&& cd RECON* \
&& cd src \
&& make && make install \
&& cd .. \
&& sed -i "s|\$path = \"\"|\$path = \"$PWD\\/bin\"|g" scripts/recon.pl \
&& echo "export PATH=\$PATH:$PWD/bin:$PWD/scripts" >> /etc/profile

# Optional Dependencies - Piler
RUN mkdir -p /opt/piler \
&& cd /opt/piler \
&& wget http://www.drive5.com/piler/piler_source.tar.gz \
&& tar -xvf piler_source.tar.gz \
&& rm -rf piler_source.tar.gz \
&& make \
&& ln -s piler2 piler \
&& echo "export PATH=\$PATH:$PWD" >> /etc/profile

# Optional Dependencies - TRF
RUN mkdir -p /opt/trf \
&& cd /opt/trf \
&& wget http://tandem.bu.edu/trf/downloads/trf409.linux64 \
&& mv trf409.linux64 trf \ 
&& chmod +x trf \
   && echo "export PATH=\$PATH:$PWD" >> /etc/profile

# Optional Dependencies - TRF
RUN mkdir -p /opt/RepeatScout \
&& cd /opt/RepeatScout \
&& wget http://bix.ucsd.edu/repeatscout/RepeatScout-1.0.5.tar.gz \
&& tar -xvf RepeatScout-*.tar.gz \
&& rm RepeatScout-*.tar.gz \
&& cd RepeatScout-1 \
&& make \
&& echo "export PATH=\$PATH:$PWD" >> /etc/profile

# Optional Depencencies - RepeatMasker
RUN mkdir -p /opt/RepeatMasker \
&& cd /opt/RepeatMasker \
&& wget http://www.repeatmasker.org/RepeatMasker-open-4-0-6.tar.gz \
&& tar -xvf RepeatMasker-*.tar.gz \
&& rm -rf RepeatMasker-*.tar.gz \
&& ln -s RepeatMasker current \
&& cd current \
&& echo "export PATH=\$PATH:$PWD" >> /etc/profile

# Optional Dependencies - Repeatmasker/RepBase
RUN cd /opt/RepeatMasker/current \
&& wget http://www.girinst.org/server/RepBase/protected/repeatmaskerlibraries/repeatmaskerlibraries-20150807.tar.gz --password=$GIRINST_PASSWORD  --user=$GIRINST_USERNAME \
&& tar -xvf repeatmaskerlibraries-*.tar.gz \
&& rm -rf repeatmaskerlibraries-*.tar.gz

# Optional Dependencies - Repeatmasker/Dfam
RUN cd /opt/RepeatMasker/current/Libraries \
&& wget http://www.dfam.org/web_download/Current_Release/Dfam.hmm.gz \
&& gunzip -f Dfam.hmm.gz

# Optional Depencencies - RMBlast
RUN mkdir -p /opt \
&& cd /opt \
&& wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/rmblast/2.2.28/ncbi-rmblastn-2.2.28-x64-linux.tar.gz \
&& tar -xvf ncbi-rmblastn-*-x64-linux.tar.gz \
&& rm ncbi-rmblastn-*-x64-linux.tar.gz \
&& mv ncbi-rmblastn-2.2.28 RMBlast \
&& cd RMBlast/bin \
&& ln -s /usr/bin/makeblastdb . \
&& ln -s /usr/bin/blastx . \
&& echo "export PATH=\$PATH:$PWD" >> /etc/profile

# Optiona Dependencies - MREP
RUN wget http://mreps.univ-mlv.fr/mreps-2.6.tar \
&& tar --directory /opt -xvf mreps-*.tar \
&& rm mreps-*.tar \
&& cd /opt/mreps \
&& make \
&& echo "export PATH=\$PATH:$PWD" >> /etc/profile

# Unmarked Dependency - shuffle (From biosquid)
RUN apt-get install -yqq biosquid
