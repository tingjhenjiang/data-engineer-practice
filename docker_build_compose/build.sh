# -- Software Stack Version

PYTHON_VERSION="3.7" #has to match the system's python version
SPARK_VERSION="3.2.0"
HADOOP_VERSION="3.2"
SCALA_VERSION="2.13"
SCALA_DETAILED_VERSION="2.13.4"
ALMOND_VERSION="0.11.1"
NB_USERs="user1" #using ; to seperate users

# -- Building the Images

docker build -f cluster-base.Dockerfile -t cluster-base .

docker build \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg hadoop_version="${HADOOP_VERSION}" \
  --build-arg SCALA_VERSION="${SCALA_VERSION}" \
  -f spark-base.Dockerfile -t spark-base .

docker build -f spark-master.Dockerfile -t spark-master .
docker build -f spark-worker.Dockerfile -t spark-worker .
docker build -f jupyterhub-base.Dockerfile -t jupyterhub-base .

docker build \
  --build-arg PYTHON_VERSION="$PYTHON_VERSION" \
  --build-arg NB_USERs="$NB_USERs" \
  -f jupyterhub-base.Dockerfile -t jupyterhub-base .

docker build \
  --build-arg SPARK_VERSION="$SPARK_VERSION" \
  --build-arg SCALA_DETAILED_VERSION="$SCALA_DETAILED_VERSION" \
  --build-arg ALMOND_VERSION="$ALMOND_VERSION" \
  -f jupyterhub-run_pyr.Dockerfile -t jupyterhub-run_pyr .