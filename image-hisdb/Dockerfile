ARG SOURCE_BRANCH

FROM intersystemsdc/irisdemo-demo-readmission:riskengine-version-2.5.2

FROM intersystemsdc/irisdemo-base-irishealthint-community:amd64-version-1.11.7

LABEL maintainer="Phillip Booth <phillip.booth@intersystems.com>"

# Changing to root so we can add the files and then use the chown command to 
# change the permissions to irisowner/irisowner.
USER root

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=readmission-hisdb-atelier-project

COPY --from=0 /tmp/export_to_hisdb.csv /tmp/ 
RUN chown irisowner:irisowner /tmp/export_to_hisdb.csv

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR
RUN chown -R irisowner:irisowner $IRIS_APP_SOURCEDIR

# Now we change back to irisowner so that the RUN command will be run with this user
USER irisowner

# IRIS Global buffers and Routine Buffers
ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Running the installer. This will load the source from our project.
RUN /demo/irisdemoinstaller.sh 

