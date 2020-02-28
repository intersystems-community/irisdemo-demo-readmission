ARG SOURCE_BRANCH

FROM intersystemsdc/irisdemo-demo-readmission:riskengine-version-2.3.1

FROM intersystemsdc/irisdemo-base-irishealthint-community:version-1.5

LABEL maintainer="Phillip Booth <phillip.booth@intersystems.com>"

COPY --from=0 /tmp/export_to_hisdb.csv /tmp/ 

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=readmission-hisdb-atelier-project

# Adding source code that will be loaded by the installer
ADD --chown=irisowner:irisuser ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh 
    #rm -f /tmp/export_to_hisdb.csv
