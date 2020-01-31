FROM intersystemsdc/irisdemo-base-synthea:readmission-demo-5000 AS synthea-patients

FROM intersystemsdc/irisdemo-base-irishealthint-community:version-1.5

LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=readmission-riskengine-atelier-project

# Adding source code that will be loaded by the installer
ADD --chown=irisowner:irisuser ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

# This file will be loaded into the APP namespace and deleted by the IRISConfig.Installer
# These are the clinical data files for comorbidity indices, clinical data and SNOMED->ICD mapping
ADD ./ComorbidityIndexMapping.tar.gz /tmp/

# ADD the compressed machine learning model to IRIS because the PMML file is 25MB
ADD --chown=irisowner:irisuser ./IRISDemo.ImportedModel.RandomForest.pmml.tar.gz /tmp/

# IRIS Global buffers and Routine Buffers
ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Adding Synthea FHIR Pateint medical histories
# Running the installer. This will load the source from our project.
# ADD --chown=irisowner:irisuser ./patient-data.tar.gz /tmp/
COPY --from=synthea-patients /tmp/patient-data.tar.gz /tmp/

RUN /usr/irissys/demo/irisdemoinstaller.sh

# These files need root permissions to delete successfully
USER root
RUN rm /tmp/ComorbidityIndexMapping.csv && \
    rm /tmp/IRISDemo.ImportedModel.RandomForest.pmml && \
    rm -rf /tmp/output
USER irisowner
