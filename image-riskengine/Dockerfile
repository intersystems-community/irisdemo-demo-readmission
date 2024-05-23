FROM intersystemsdc/irisdemo-base-synthea:readmission-demo-5000 AS synthea-patients

FROM intersystemsdc/irisdemo-base-irishealthint-community:amd64-version-1.13.0

LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Changing to root so we can add the files and then use the chown command to 
# change the permissions to irisowner/irisowner.
USER root

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=readmission-riskengine-atelier-project

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR
RUN chown -R irisowner:irisowner $IRIS_APP_SOURCEDIR

# This file will be loaded into the APP namespace and deleted by the IRISConfig.Installer
# These are the clinical data files for comorbidity indices, clinical data and SNOMED->ICD mapping
ADD ./ComorbidityIndexMapping.tar.gz /tmp/
RUN chown irisowner:irisowner /tmp/*.csv

# ADD the compressed machine learning model to IRIS because the PMML file is 25MB
ADD ./IRISDemo.ImportedModel.RandomForest.pmml.tar.gz /tmp/
RUN chown irisowner:irisowner /tmp/*.pmml

# Adding Synthea FHIR Pateint medical histories
# Running the installer. This will load the source from our project.
# ADD --chown=irisowner:irisuser ./patient-data.tar.gz /tmp/
COPY --from=synthea-patients /tmp/patient-data.tar.gz /tmp/
RUN chown irisowner:irisowner /tmp/*.csv

# Now we change back to irisowner so that the RUN command will be run with this user
USER irisowner

# IRIS Global buffers and Routine Buffers
ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Running the installer. This will load the source from our project.
RUN /demo/irisdemoinstaller.sh 