FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive 

# Actualizamos los paquetes e instalamos herramientas básicas
RUN apt-get update
RUN apt-get -y install build-essential

# Instalamos herramientas necesarias
RUN apt-get -y install openjdk-8-jdk openjdk-8-jre
RUN apt-get -y install git
RUN apt-get -y install wget
RUN apt-get -y install ant
RUN apt-get -y install ruby

# Instalamos apache tomcat
WORKDIR /usr/local
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.52/bin/apache-tomcat-7.0.52.tar.gz -O tomcat.tar.gz
RUN tar -zxvf tomcat.tar.gz
RUN rm tomcat.tar.gz
RUN mv *tomcat* tomcat # Esto es simplemente para renombrar la carpeta para que el nombre simplemente sea 'tomcat'

# Instalamos ciao
RUN git clone https://github.com/ciao-lang/ciao
WORKDIR ciao
RUN ./ciao-boot.sh global-install

# Instalamos UFleSe
WORKDIR /usr/local
RUN git clone https://github.com/FuzzyLP/UFleSe
WORKDIR UFleSe
RUN rm -rf ciao
RUN ./prepare.sh

# Copiamos el fichero de build a la carpeta del código
WORKDIR flese
COPY utils/build.xml .

# Compilamos el código del proyecto
RUN ant -f build.xml

# Una vez compilado, movemos todo el código a la carpeta donde están
# los elementos del servidor
RUN cp -r build/classes WebContent/WEB-INF/

# Ahora lo que hacemos es encapsular todo lo del servidor a un fichero
# .war para poder desplegarlo y lo mandamos todo a la carpeta de aplicaciones
# del servidor apache tomcat
WORKDIR WebContent/
RUN jar -cvf /usr/local/tomcat/webapps/flese.war *

CMD ["sh", "-c", "/usr/local/tomcat/bin/catalina.sh start && tail -f /usr/local/tomcat/logs/catalina.out"]
