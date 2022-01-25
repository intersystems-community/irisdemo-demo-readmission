FROM intersystemsdc/irisdemo-base-irishealthint-community:version-1.10.3

LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Changing to root so we can add the files and then use the chown command to 
# change the permissions to irisowner/irisowner.
USER root

# Name of the project folder ex.: my-atelier-project
ARG IRIS_PROJECT_FOLDER_NAME=readmission-risksrv-atelier-project

# Adding source code that will be loaded by the installer
ADD ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR
RUN chown -R irisowner:irisowner $IRIS_APP_SOURCEDIR

ADD ./html/DemoLangingPage.png $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/MLWorkflow.png $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/image-map-resizer/js/imageMapResizer.min.js $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD ./html/image-map-resizer/js/imageMapResizer.map $ISC_PACKAGE_INSTALLDIR/csp/appint/
RUN chown -R irisowner:irisowner $ISC_PACKAGE_INSTALLDIR/csp/appint/

# Now we change back to irisowner so that the RUN command will be run with this user
USER irisowner

# IRIS Global buffers and Routine Buffers
ENV IRIS_GLOBAL_BUFFERS=128
ENV IRIS_ROUTINE_BUFFERS=64

# Running the installer. This will load the source from our project.
RUN /demo/irisdemoinstaller.sh 