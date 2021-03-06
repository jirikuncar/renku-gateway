#!/bin/bash
#
# Copyright 2018 - Swiss Data Science Center (SDSC)
# A partnership between École Polytechnique Fédérale de Lausanne (EPFL) and
# Eidgenössische Technische Hochschule Zürich (ETHZ).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

MINIKUBE_IP=`minikube ip`
CURRENT_CONTEXT=`kubectl config current-context`

# On Mac we can not use `pipenv run quart run` because of
# https://www.telepresence.io/reference/methods
QUART_EXECUTABLE=`pipenv --venv`/bin/quart

echo "You are going to exchange k8s deployments using the following context: ${CURRENT_CONTEXT}"
read -p "Do you want to proceed? [y/n]"
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "================================================================================================================="
echo "Once telepresence has started, copy-paste the following command to start the development server:"
echo "QUART_DEBUG=1 \
QUART_APP=run:app.app \
PYTHONASYNCIODEBUG=1 \
${QUART_EXECUTABLE} run"
echo "================================================================================================================="

telepresence --swap-deployment renku-gateway --namespace renku --method inject-tcp --expose 5000 --run-shell
